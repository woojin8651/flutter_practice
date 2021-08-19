import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_practice_app/model/item.dart';
import 'package:flutter_practice_app/viewmodel/homeVM.dart';
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
    return Column(
      children: [
        Text("테스트용"),
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

  int indexOffset = 5000; //
  DateTime pageDate;

  HomeViewModel vm = HomeViewModel(); //home 화면 뷰모델
  DateFormat dfm = DateFormat("yyyy-MM-dd");
  var pvEmpty =  Container( //빈 화면
  width: 100.0,
  height: 100.0,
  padding: EdgeInsets.all(10),
  color: Colors.blue,
  child: Text("오류가 나쩌용"),
  );

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
        height: 300,
        child: PageView.builder(
          controller:  PageController(initialPage: indexOffset),
          itemBuilder: (ctx,idx) => dayPage(pageDate.add(Duration(days: idx - indexOffset))),
        )
        ,
      ),
    );
  }
  Widget dayPage(DateTime day){
    return FutureBuilder<List<Item>>(
      future: this.vm.fetchDayBusket(day),
      builder: (context,snapshot){
        if(snapshot.hasData){
          return itemList(snapshot.data, day);
        }
        else if(snapshot.hasError){
          return Text("에러");
        }
        return CircularProgressIndicator();
      },
    );
  }
  Widget itemList(List<Item> data,DateTime day){
    return Scaffold(
      appBar: AppBar(
        title: Text(dfm.format(day)),
        actions: [
          IconButton(icon: Icon(Icons.add,
          color: Colors.white),
              onPressed: (){
                //누르면 추가할 수 있는 dialog 띄우기
              })
        ],
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: data.map((e) => ListTile(
          title: Text(e.name),
          subtitle: Text("${e.amount} => ${e.cost}원"),
        )).toList(),
      ),
    );
  }
}


