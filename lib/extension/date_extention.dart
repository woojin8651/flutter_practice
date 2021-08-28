import 'package:flutter_practice_app/model/Budget.dart';
import 'package:intl/intl.dart';

extension DateOnlyCompare on DateTime {

  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
        && this.day == other.day;
  }

  List<DateTime> calculateDaysInterval(DateTime endDate) {
    List<DateTime> days = [];
    for (DateTime d = this;
    d.isBefore(endDate);
    d.add(Duration(days: 1))) {
      days.add(d);
    }
    return days;
  }
}
class Formats{
  static DateFormat dfm = DateFormat("yyyy-MM-dd");
}
class DateCalculation{
  static bool inRange(String st,String ed,String cmp){ //st 랑 ed 사이에 cmp가 있나
    var stD = Formats.dfm.parse(st);
    var edD = Formats.dfm.parse(ed);
    var cmpD = Formats.dfm.parse(cmp);
    return !(cmpD.isAfter(edD)||cmpD.isBefore(stD));
  }
  static bool inRangeR(DateTime day, int repeatD, String repeatP, String cmp){
    String prev;
    String next;
    if(day.day<repeatD){ // 이전
      switch(repeatP){
        case Budget.repeatMonth:
          prev = Formats.dfm.format(DateTime(day.year,day.month-1,repeatD));
          next = Formats.dfm.format(DateTime(day.year,day.month,repeatD-1));
          return inRange(prev, next, cmp);
          break;
        case Budget.repeatYear:
          prev = Formats.dfm.format(DateTime(day.year-1,day.month,repeatD));
          next = Formats.dfm.format(DateTime(day.year,day.month,repeatD-1));
          return inRange(prev, next, cmp);
          break;
        default:
          return false;
      }
    }
    else{ //이후
      switch(repeatP){
        case Budget.repeatMonth:
          prev = Formats.dfm.format(DateTime(day.year,day.month,repeatD));
          next = Formats.dfm.format(DateTime(day.year,day.month+1,repeatD-1));
          return inRange(prev, next, cmp);
          break;
        case Budget.repeatYear:
          prev = Formats.dfm.format(DateTime(day.year,day.month,repeatD));
          next = Formats.dfm.format(DateTime(day.year+1,day.month,repeatD-1));
          return inRange(prev, next, cmp);
          break;
        default:
          return false;
      }
    }
  }
}