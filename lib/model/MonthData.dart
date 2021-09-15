import 'dart:math';

import 'Item.dart';

class MonthData{

  MonthData({this.month,this.year,this.dateSum});
  int month;
  int year;
  List<DateSum> dateSum;
  int maxDateSum(){
    if(dateSum.isEmpty) return 0;
    return dateSum.fold(0, (p, e) => max(p,e.cost));
  }
}
class DateSum{
  int day;
  int cost;
  DateSum({this.day = 1,this.cost = 0});
  void addCost(int cost){
    this.cost += cost;
  }

}