import 'Item.dart';

class MonthData{

  MonthData({this.month,this.year,this.dateSum});
  int month;
  int year;
  List<DateSum> dateSum;

}
class DateSum{
  int day;
  int cost;

  DateSum({this.day = 1,this.cost = 0});

  void addCost(int cost){
    this.cost += cost;
  }

}