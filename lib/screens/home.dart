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
              height: 600,
              margin: EdgeInsets.all(30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Scaffold(
                    body: PageView.builder(
                      physics: ScrollPhysics(
                      ),
                      controller:  PageController(initialPage: indexOffset,
                          viewportFraction: 0.8),
                      itemBuilder: (ctx,idx) => dayPage(pageDate.add(Duration(days: idx - indexOffset))),
                    ),
                      floatingActionButton: FloatingActionButton(
                        child: Icon(Icons.add, color: Colors.white,),
                        onPressed: (){
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
        title: Center(child: Text(dfm.format(day),style: TextStyle(
          color: Colors.blue
        ),)),
        backgroundColor: Colors.white,
      ),
      body: itemList(day)
    );
  }
  Widget itemList(DateTime day){
    return FutureBuilder<List<Item>>(
      future: this.vm.fetchDayBusket(day),
      builder: (context,snapshot){
        if(snapshot.hasData){
          return ListView(
            children: snapshot.data.map((e) => ListTile(
              title: Text(e.name),
              subtitle: Text("${e.amount} => ${e.cost}원"),
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
}


