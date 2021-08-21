import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_practice_app/model/dbHelper.dart';
import 'package:flutter_practice_app/model/item.dart';
import 'package:flutter_practice_app/viewmodel/homeVM.dart';
import 'package:flutter_practice_app/extension/date_extention.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("Home");
    return Scaffold(
        appBar: AppBar(
        title: Center(child: Text('홈')),
    ),
    drawer: Drawer(),
    body: HomeFragment(),
    );
  }
}

// 프레그먼트 화면
class HomeFragment extends StatelessWidget {
  const HomeFragment({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DailyViewPage(),
      ],
    );
  }
}

// 뷰 페이저 있는 화면
class DailyViewPage extends StatefulWidget {

  @override
  _DailyViewPageState createState() => _DailyViewPageState();
}

class _DailyViewPageState extends State<DailyViewPage> {

  final int indexOffset = 5000; //
  DateTime pageDate;
  DateTime currDate;
  HomeViewModel vm = HomeViewModel.instance();//home 화면 뷰모델

  void refresh(){
    setState(() {
    });
  }
  void setCurrDate(DateTime date){
    setState(() {
      currDate = date;
    });
  }
  @override
  void initState() {
    super.initState();
    pageDate = DateTime.now(); //오늘
    log("init");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.0),
      child: dailyPages(),
      );
  }
  //
  Widget dailyPages(){
    return Center(
           child: Container(
              width: 300,
              height: 600,
              margin: EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Scaffold(
                    body: PageView.builder(
                      controller:  PageController(initialPage: indexOffset,
                          viewportFraction: 0.7),
                      itemBuilder: (ctx,idx) {
                        return dayPage(pageDate.add(Duration(days: idx - indexOffset)));
                      },
                      onPageChanged: (idx){
                        setCurrDate(pageDate.add(Duration(days: idx - indexOffset)));
                      },
                    ),
                      floatingActionButton: FloatingActionButton(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.add, color: Colors.blue,),
                        onPressed: (){
                          showItemDialog();
                        },
                      )
                  )
                ),
            ),
        );
  }
  Widget dayPage(DateTime day){
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        title: Center(child: Text(Formats.dfm.format(day),
          style: TextStyle(color: day.isAtSameMomentAs(pageDate) ? Colors.red:Colors.blue))
        ),
        backgroundColor: Colors.white,
      ),
      body: itemList(day),
      backgroundColor:Colors.blue,
    );
  }
  Widget itemList(DateTime day){
    return FutureBuilder<List<Item>>(
      future: this.vm.fetchDayBusket(day),
      builder: (context,snapshot){
        if(snapshot.hasData){
          log("hasdata");
          return ListView(
            children: snapshot.data.map((e) => ListTile(
              title: WhiteText(e.name),
              subtitle: WhiteText("${e.amount} => ${e.cost}원"),
            )).toList(),
          );
        }
        else if(snapshot.hasError){
          return Text("에러");
        }
        return Center(
          child: SizedBox(
            child: CircularProgressIndicator(),
            height: 100,
            width: 100,
          ),
        );
      },
    );
  }
  void showItemDialog() async{
    await showDialog(context: context,
        builder: (ctx) => ItemDialog(refresh: refresh,date: currDate,));
  }
}

class WhiteText extends Text{
  WhiteText(String str):super(str, style: TextStyle(color: Colors.white));
}
// ignore: must_be_immutable
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

  void clickCancel(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: content(),
      actions: [
        TextButton(onPressed: clickAdd, child: Text("추가")),
        TextButton(onPressed: clickCancel, child: Text("취소")),
      ],
    );
  }

  Widget content(){
    return Container(
      width: 300,
      height: 600,
      child: ListView(
          children: [
            ListTile(title: TextField(decoration: textDecoration("상품명"),controller:nameTec,),),
            ListTile(title: TextField(keyboardType: TextInputType.number,decoration: textDecoration("가격"),controller:costTec,),),
            ListTile(title: TextField(keyboardType: TextInputType.number,decoration: textDecoration("수량"),controller:amountTec,),),
            Text(statement)
          ],
        ),
    );
  }
}



