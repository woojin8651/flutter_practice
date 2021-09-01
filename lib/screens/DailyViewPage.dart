// 뷰 페이저 있는 화면
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_practice_app/extension/Colors.dart';
import 'package:flutter_practice_app/model/Item.dart';
import 'package:flutter_practice_app/viewmodel/HomeVM.dart';
import 'package:flutter_practice_app/extension/date_extention.dart';
import 'ItemDialog.dart';
class DailyViewPage extends StatefulWidget {
  DailyViewPage({this.refresh});
  Function refresh;
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
    pageDate = DateTime.now();
    setCurrDate(pageDate);
    log("DailyViewPageInitSate");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: dailyPages(),
    );
  }
  //
  Widget dailyPages(){
    return Center(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(gradient: AppColors.BgGradient),
            child: Scaffold(
                backgroundColor: Colors.transparent,
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
                  elevation: 0,
                  backgroundColor: Colors.white.withOpacity(0.7),
                  child: Icon(Icons.add, color: AppColors.BgColorD,),
                  onPressed: (){
                    showItemDialog();
                  },
                )
            ),
          )
      ),
    );
  }
  //페이지
  TextStyle title_style(DateTime day){
    return TextStyle(color: day.isAtSameMomentAs(pageDate)?Colors.white :Colors.white.withOpacity(0.6),
        fontWeight:  day.isAtSameMomentAs(pageDate)?FontWeight.w400:FontWeight.w300,
        fontSize: 23);
  }
  Widget dayPage(DateTime day){
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          title: Center(child: Text( Formats.dfm.format(day),
              style: title_style(day))
          ),
          backgroundColor: Colors.transparent,
        ),
        body:ItemLoadModel(day, ret: makeItemList, err: Text("에러")),
        backgroundColor:Colors.grey[300].withOpacity(0.2)
    );
  }
// ignore: non_constant_identifier_names
  Widget ItemLoadModel(DateTime day,{Function(List<Item> item) ret,Widget err}) {
    return FutureBuilder<List<Item>>(
      future: this.vm.fetchDayBusket(day),
      builder: (context,snapshot){
        if(snapshot.hasData){
          log("hasdata");
          return ret(snapshot.data);
        }
        else if(snapshot.hasError){
          return err;
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

  final itemListBoxDecoration = BoxDecoration(
      color: Colors.transparent,
      border: Border.all(
          width: 1,
          color: Colors.white.withOpacity(0.5)
      )
  );

  Widget makeItemList(List<Item> data){
    return ListView(
      children: [
        ////////////당일 아이템 리스트////////////////////
        Container(
          padding: EdgeInsets.all(5),
          decoration: itemListBoxDecoration,
          width: 300,
          height: 300,
          child: ListView(
            children: data.map((e) => ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: ListTile(
                  onLongPress: () async{
                    await showDialog(context: context,
                        builder: (ctx) => ItemLongDialog(item: e,refresh: this.widget.refresh,));
                  },
                  title: ItemTitleText(e.name),
                  subtitle: ItemContentText("${e.amount}개  ${e.cost}원\n"
                      "1개 당 ${(e.cost / e.amount).toDouble()}원"),
                )
            )).toList(),
          ),
        ),
        ////////////총합////////////////////
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: ItemContentText("총 비용은 ${data.fold(0, (sum, e) => sum+e.cost)}원")),
        )
      ],
    );
  }

  void showItemDialog() async{
    await showDialog(context: context,
        builder: (ctx) => ItemDialog(refresh: this.widget.refresh,date: currDate,));
  }

}

class ItemContentText extends Text{
  ItemContentText(String str):super(str, style: TextStyle(color: Colors.white.withOpacity(0.7)));
}
class ItemTitleText extends Text{
  ItemTitleText(String str):super(str, style: TextStyle(fontFamily: "BlackHanSans",color: Colors.white.withOpacity(1)));
}