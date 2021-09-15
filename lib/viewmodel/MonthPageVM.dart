import 'dart:developer';

import 'package:flutter_practice_app/extension/date_extention.dart';
import 'package:flutter_practice_app/model/DBItemHelper.dart';
import 'package:flutter_practice_app/model/Item.dart';
import 'package:flutter_practice_app/model/MonthData.dart';

class MonthPageVM{

  MonthPageVM();

  factory MonthPageVM.instance(){
    return MonthPageVM();
  }

  Future<List<MonthData>> getMonthData() async{
    List<MonthData> monthList = [];
    var item = await DBItemHelper.getItem();
    item.sort((a,b)=> Formats.compareDateWithString(a.date, b.date));
    //날짜순 정렬

    item.forEach((element) {
      if(monthList.isEmpty||monthList.last.month<Formats.dfm.parse(element.date).month||monthList.last.year<Formats.dfm.parse(element.date).year)
        monthList.add(MonthData(
            month: Formats.dfm.parse(element.date).month,
            year:Formats.dfm.parse(element.date).year,
            dateSum: []));
      if(monthList.last.dateSum.isEmpty || monthList.last.dateSum.last.day<Formats.dfm.parse(element.date).day)
        monthList.last.dateSum.add(DateSum(day: Formats.dfm.parse(element.date).day));
      monthList.last.dateSum.last.addCost(element.cost);
    });
    log("MonthList,${monthList.last.month}");
    return monthList;

  }
}
