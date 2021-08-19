import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'unit.dart';
class Item{
  static const String sql_id="id";
  static const String sql_date="date";
  static const String sql_name="name";
  static const String sql_cost="cost";
  static const String sql_amount="amount";
  static const String sql_unitCode="unitCode";

  String id;
  DateTime date;
  String name;
  int cost;
  int amount;
  int unitCode;

  Item({
    @required this.date,
    @required this.name,
    this.id,
    this.cost = 0,
    this.amount= 0,
    this.unitCode = Unit.U_Undefine}){
    if(id == null){
    this.id = DateTime.now().toString();
    }
  }
  Map<String,dynamic> toMap(){
    return{
      sql_id:id,
      sql_date:date,
      sql_name:name,
      sql_cost:cost,
      sql_amount:amount,
      sql_unitCode:unitCode
    };
  }
}
