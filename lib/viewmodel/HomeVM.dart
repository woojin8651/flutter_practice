import 'dart:developer';
import 'package:flutter_practice_app/model/DBItemHelper.dart';
import 'package:flutter_practice_app/model/Item.dart';
import 'package:flutter_practice_app/extension/date_extention.dart';
class HomeViewModel{

  HomeViewModel();

  factory HomeViewModel.instance(){
    return HomeViewModel();
  }

  Future<List<Item>> fetchDayBusket(DateTime day) async{

      var list = await DBItemHelper.getItem();
      log(list.toString());
      return list.where((item) => Formats.dfm.format(day) == item.date).toList();
  }

  Future<void> addNewItem(Item item) async{
    try{
      await DBItemHelper.insertItem(item);
    }catch(e){
      throw Exception("insert error");
    }
  }

  Future<void> modifyItem(Item item) async{
    try{
      await DBItemHelper.updateItem(item);
    }catch(e){
      throw Exception("insert error");
    }
  }

  Future<void> deleteItem(Item item) async{
    try{
      await DBItemHelper.deleteItem(item);
    }catch(e){
      throw Exception("insert error");
    }
  }
}