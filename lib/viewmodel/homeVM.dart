import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter_practice_app/model/item.dart';
import 'package:flutter_practice_app/extension/date_extention.dart';
class HomeViewModel{
  Future<List<Item>> fetchDayBusket(DateTime day) async{

    return Future.delayed(Duration(milliseconds: 300),(){
      return sample;
    });
  }
  List<Item> sample = [
    Item(date: DateTime.now(),name: "감자",cost: 100,amount: 300),
    Item(date: DateTime.now(),name: "감자",cost: 100,amount: 300),
    Item(date: DateTime.now(),name: "감자",cost: 100,amount: 300),
    Item(date: DateTime.now(),name: "감자",cost: 100,amount: 300),
    Item(date: DateTime.now(),name: "감자",cost: 100,amount: 300),
    Item(date: DateTime.now(),name: "감자",cost: 100,amount: 300),Item(date: DateTime.now(),name: "감자",cost: 100,amount: 300),
    Item(date: DateTime.now(),name: "감자",cost: 100,amount: 300),
    Item(date: DateTime.now(),name: "감자",cost: 100,amount: 300),
  ];
}