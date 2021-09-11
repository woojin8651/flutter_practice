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
      if(monthList.isEmpty||monthList.last.month<Formats.dfm.parse(element.date).month)
        monthList.add(MonthData(
            month: Formats.dfm.parse(element.date).month,
            year:Formats.dfm.parse(element.date).year,
            dateSum: []));


    });
    return monthList;
  }

}
