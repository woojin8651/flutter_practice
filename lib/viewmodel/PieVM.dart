import 'package:flutter_practice_app/model/Budget.dart';
import 'package:flutter_practice_app/model/DBBudgetHelper.dart';

class PieVM{

  PieVM();

  factory PieVM.instance(){
    return PieVM();
  }
  Future<List<Budget>> fetchData() async{
    List<Budget> list = await DBBudgetHelper.getBudget();
    return list;
  }

}