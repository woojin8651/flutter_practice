import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_app/extension/Colors.dart';
import 'package:flutter_practice_app/extension/date_extention.dart';
import 'package:flutter_practice_app/model/Budget.dart';
import 'package:flutter_practice_app/model/DBBudgetHelper.dart';
import 'package:flutter_practice_app/model/DBItemHelper.dart';
import 'package:flutter_practice_app/model/Item.dart';
class PieVM{
  static const String PieLeft = '잔금';
  static const String PieItem = '사용';

  List<PieSet> PieSets = [];

  PieVM();

  factory PieVM.instance(){
    return PieVM();
  }

  Future<List<PieSet>> fetchPie(DateTime day) async{
    List<Budget> bList = await DBBudgetHelper.getBudget();
    List<Item> iList = await DBItemHelper.getItem();
    PieSets.clear();
    bList.forEach((budget) {
      if(budget.repeat == 0){ //반복 x
        int iSum = iList.where((item) =>
            DateCalculation.inRange(budget.stDay, budget.edDay, item.date))
            .fold(0, (sum, e) => sum + e.cost);
        if(iSum >= budget.total) PieSets.add(PieSet(budget,{PieItem:iSum.toDouble()}));
        else PieSets.add(PieSet(budget,{PieLeft:(budget.total - iSum).toDouble(), PieItem:iSum.toDouble()}));
      }
      else{ // 반복 o
        int iSum = iList.where((item) =>
            DateCalculation.inRangeR(day, budget.repeatDay, budget.repeatP, item.date))
            .fold(0, (sum, e) => sum + e.cost);
        if(iSum >= budget.total) PieSets.add(PieSet(budget,{PieItem:iSum.toDouble()}));
        else PieSets.add(PieSet(budget, {PieLeft:(budget.total - iSum).toDouble(), PieItem:iSum.toDouble()}));
      }
    });
    return PieSets;
  }
  Future<List<RadarDataSet>> fetchRadar(DateTime day,Budget budget) async{
    List<Item> iList = await DBItemHelper.getItem();
    List<double> cost = [0.99999,1,1,1,1];
    List<RadarDataSet> dataSet = [];
    if(budget.repeat == 0){
      iList.where((item) =>
          DateCalculation.inRange(budget.stDay, budget.edDay, item.date))
          .forEach((item) {
            cost[item.unitCode] += item.cost.toDouble();
      });
      double sum = cost.fold(0.0, (pre, item) => pre + item);
      cost = cost.map((e){
        if(e/sum >0.1) return e/sum;
        else return 0.1;
      }).toList();
      log("sum = $sum, cost => ${cost.toString()}");
    }
    else{
      iList.where((item) =>
          DateCalculation.inRangeR(day, budget.repeatDay, budget.repeatP, item.date))
          .forEach((item) {
        cost[item.unitCode] += item.cost.toDouble();
      });
      double sum = cost.fold(0.0, (pre, item) => pre + item);
      cost = cost.map((e){
        if(e/sum >0.1) return e/sum;
        else return 0.1;
      }).toList();
    }
    dataSet.add(RadarDataSet(
      fillColor: AppColors.BgColorD.withOpacity(0.5),
      borderColor: AppColors.BgColorD,
      dataEntries: cost.map((e) => RadarEntry(value: e)).toList(),
    ));
    log("dataset: ${dataSet.toString()}");
    return dataSet;
  }
  Future<void> insertBudget(Budget budget) async{
    try{
      await DBBudgetHelper.insertBudget(budget);
    }catch(e){
      throw Exception("insert error");
    }
  }

  Future<void> modifyBudget(Budget budget) async{
    try{
      await DBBudgetHelper.updateBudget(budget);
    }catch(e){
      throw Exception("insert error");
    }
  }

  Future<void> deleteBudget(Budget budget) async{
    try{
      await DBBudgetHelper.deleteBudget(budget);
    }catch(e){
      throw Exception("insert error");
    }
  }
}
class PieSet{
  Map<String,double> PieData;
  Budget budget;
  PieSet(this.budget,this.PieData);
}