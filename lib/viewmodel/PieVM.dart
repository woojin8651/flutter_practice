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
        if(iSum >= budget.total) PieSets.add(PieSet(budget,{PieLeft:iSum.toDouble()}));
        else PieSets.add(PieSet(budget,{PieLeft:(budget.total - iSum).toDouble(), PieItem:iSum.toDouble()}));
      }
      else{ // 반복 o
        int iSum = iList.where((item) =>
            DateCalculation.inRangeR(day, budget.repeatDay, budget.repeatP, item.date))
            .fold(0, (sum, e) => sum + e.cost);
        if(iSum >= budget.total) PieSets.add(PieSet(budget,{PieLeft:iSum.toDouble()}));
        else PieSets.add(PieSet(budget, {PieLeft:(budget.total - iSum).toDouble(), PieItem:iSum.toDouble()}));
      }
    });
    return PieSets;
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