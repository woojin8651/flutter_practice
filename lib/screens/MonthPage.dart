import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_practice_app/extension/Colors.dart';
import 'package:flutter_practice_app/model/MonthData.dart';
import 'package:flutter_practice_app/viewmodel/MonthPageVM.dart';



class MonthPage extends StatelessWidget {

  MonthPageVM vm = MonthPageVM.instance();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
      color: Colors.black.withOpacity(0.5),
      child:
      Scaffold(
        appBar: AppBar(title:  Center(
          child: Text("월간 소비 내역",style: const TextStyle(color: Color(0xff000000), fontSize: 20)),
        ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        body: FutureBuilder<List<MonthData>>(
          future: this.vm.getMonthData(),
          builder: (ctx,snapshot){
            if(snapshot.hasData){
              return RawScrollbar(
                isAlwaysShown: true,
                thumbColor: Colors.black.withOpacity(0.5),
                radius: Radius.circular(20),
                thickness: 5,
                child: ListView(
                  children: monthDataMonth(snapshot.data),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,),
              );
            }
            else if(snapshot.hasError){
              return Text("MonthPage 에러");
            }
            return  Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 100,
                width: 100,
              ),
            );
          },
        ),
      ),
    );
  }
  List<Widget> monthDataMonth(List<MonthData> monthDatas){
    List<Widget> ret = [];
    monthDatas.forEach((monthData) {
      ret.addAll(monthDataDataSum(monthData));
    });
    return ret;
  }
  List<Widget> monthDataDataSum(MonthData monthData){
    final TileTitleStyle = TextStyle(
        fontFamily: "BlackHanSans",
        color: Colors.white,
        fontSize: 20
    );
    final TileSubStyle = TextStyle(
        color: Colors.white,
        fontSize: 10
    );
    final TileDayStyle = TextStyle(
        color: Colors.white,
        fontSize: 15
    );
    List<Widget> ret = [];

    ret.add(Container(
      color:AppColors.MonthColor[monthData.month-1] ,
      child: ListTile( // 월
        title: Center(child: Text("${monthData.month}월 일간 내역",style: TileTitleStyle,)),
        subtitle: Container(
          child: Text("${monthData.year}년",
              style: TileSubStyle),
          alignment: Alignment.topRight,
        )
      ),
    ),);
    ret.addAll(List.generate(monthData.dateSum.length, (idx) =>
        Container(
          color:AppColors.MonthColor[monthData.month-1],
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 10,right : 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${monthData.month}월 ${monthData.dateSum[idx].day}일 ",
                      style: TileDayStyle),
                  Text("${monthData.dateSum[idx].cost}원",
                    style: TileDayStyle,)
                ],
              ),
            ),
          ),
        )).toList());
    return ret;
  }
}