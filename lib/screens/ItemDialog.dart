// ignore: must_be_immutable


import 'package:flutter/material.dart';
import 'package:flutter_practice_app/extension/date_extention.dart';
import 'package:flutter_practice_app/model/item.dart';
import 'package:flutter_practice_app/viewmodel/homeVM.dart';

class ItemDialog extends StatefulWidget {
  Function refresh;
  DateTime date;
  ItemDialog({this.refresh,this.date});

  @override
  _ItemDialogState createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {

  HomeViewModel vm = HomeViewModel.instance();//home 화면 뷰모델
  String statement="";

  final textDecoration = (String hint) => InputDecoration(
      border: OutlineInputBorder(),
      labelText: hint
  );

  final nameTec = TextEditingController();
  final costTec = TextEditingController();
  final amountTec = TextEditingController();

  void clickAdd() async{
    if(nameTec.text.isEmpty){
      setState(() {
        statement = "시발 이름좀 넣어";
      });
    }
    else {
      await vm.addNewItem(Item(
        date: Formats.dfm.format(this.widget.date),
        name: nameTec.text,
        cost: int.parse(costTec.text),
        amount: int.parse(amountTec.text),
      ));
      this.widget.refresh();
      Navigator.pop(context);
    }
  }

  void clickCancel(BuildContext context){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: content(),
      actions: [
        TextButton(onPressed: clickAdd , child: Text("추가")),
        TextButton(onPressed: () => clickCancel(context), child: Text("취소")),
      ],
    );
  }

  Widget content(){
    return Container(
      width: 300,
      height: 300,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(title: TextField(decoration: textDecoration("상품명"),controller:nameTec,),),
            ListTile(title: TextField(keyboardType: TextInputType.number,decoration: textDecoration("가격"),controller:costTec,),),
            ListTile(title: TextField(keyboardType: TextInputType.number,decoration: textDecoration("수량"),controller:amountTec,),),
            Text(statement)
          ],
        ),
      ),
    );
  }
}
class ItemLongDialog extends StatelessWidget {
  Item item;
  Function refresh;
  HomeViewModel vm = HomeViewModel.instance();

  ItemLongDialog({this.item,this.refresh});

  void clickModify(BuildContext context){

  }
  void clickDelete(BuildContext context) async{
   await vm.deleteItem(item);
   this.refresh();
   Navigator.pop(context);
  }
  void clickCancel(BuildContext context){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Container(
        width: 200,
        height: 200,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              TextButton(onPressed: () => clickModify(context), child: Text("수정")),
              TextButton(onPressed: () => clickDelete(context), child: Text("삭제")),
              TextButton(onPressed: () => clickCancel(context), child: Text("취소")),
            ],
          ),
        ),
      )
    );
  }
}

