import 'package:flutter/material.dart';
import 'unit.dart';
class Item{

  String name;
  int cost;
  int amount;
  int unitCode;
  Item({@required this.name,this.cost = 0,this.amount= 0,this.unitCode = Unit.U_Undefine});


}