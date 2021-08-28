import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_practice_app/extension/Colors.dart';
import 'package:flutter_practice_app/model/Budget.dart';
import 'package:flutter_practice_app/screens/BudgetDialog.dart';
import 'package:flutter_practice_app/viewmodel/PieVM.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PieChartView extends StatefulWidget {
  PieChartView({this.refresh});
  Function refresh;
  @override
  _PieChartViewState createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> with TickerProviderStateMixin{

  AnimationController _controller;
  DateTime _pageDate;
  Budget curBudget;
  PieVM vm;
  List<Icon> icons = [Icon(Icons.add,color: Colors.white)
    ,Icon(Icons.delete,color: Colors.white)
    ,Icon(Icons.edit,color: Colors.white)];
  void refresh(){
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    vm = PieVM.instance();
    _pageDate = DateTime.now();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(20.0),
      child: piePages(),
    );
  }
  Widget piePages(){
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          color: Colors.white,
          width: 400,
          height: 400,
          child: Scaffold(
            body:  FutureBuilder(
              future: vm.fetchPie(_pageDate),
              builder: (ctx,snapshot){
                if(snapshot.hasData){
                  if((snapshot.data as List<PieSet>).isNotEmpty) {
                    curBudget = (snapshot.data as List<PieSet>)[0].budget;
                  }
                  return budgetChart(snapshot.data);
                }
                else if(snapshot.hasError){
                  return Center(child: Text("에러"));
                }
                return Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    height: 100,
                    width: 100,
                  ),
                );
              },
            ),
            floatingActionButton: _getFSD(),
          ),
        ),
      ),
    );
  }
  Widget budgetChart(List<PieSet> datas){
    return PageView.builder(
      onPageChanged: (idx){
        curBudget  = datas[idx].budget;
      },
        itemCount: datas.length,
        itemBuilder: (ctx,idx){
          return Center(
            child: Column(
              children: [
                Center(
                  child: Text("예산: ${datas[idx].budget.total}원")
                ),
                Center(
                    child: Text("사용: ${datas[idx].PieData[PieVM.PieItem].toInt()}원")
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(datas[idx].budget.stDay),
                      Text("~"),
                      Text(datas[idx].budget.stDay),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*2/3,
                  height: MediaQuery.of(context).size.width*2/3,
                  child: PieChart(

                    dataMap: datas[idx].PieData,
                    animationDuration: Duration(milliseconds: 800),
                    chartRadius: MediaQuery.of(context).size.width/3.2,
                    chartType: ChartType.ring,
                    chartValuesOptions: ChartValuesOptions(
                      showChartValuesInPercentage: true
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
  final styleT = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.white,
      fontSize: 16.0);

  void pressFAB(int idx){
    switch(idx){
      case 0:
        showBudgetDialog();
        break;
      case 1:
        if(curBudget != null)
          showBudgetDeleteDialog(curBudget);
        break;
    }
  }
  Widget _getFSD(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(icons.length, (int index) {
        Widget child = new Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child:  ScaleTransition(
            scale:  CurvedAnimation(
              parent: _controller,
              curve:  Interval(
                  0.0,
                  1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut
              ),
            ),
            child:  FloatingActionButton(
              backgroundColor: AppColors.BgColorD,
              child: icons[index],
              onPressed: () => pressFAB(index),
            ),
          ),
        );
        return child;
      }).toList()..add(
         FloatingActionButton(
           backgroundColor: AppColors.BgColorD,
          heroTag: null,
          child:  AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return Transform(
                transform: Matrix4.rotationZ(_controller.value * 0.5 * 3.141592),
                alignment: FractionalOffset.center,
                child: Icon(_controller.isDismissed ? Icons.menu : Icons.close,color: Colors.white,),
              );
            },
          ),
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
        ),
      ),
    );
  }

  void showBudgetDialog() async{
    log("클릭");
    await showDialog(context: context,
        builder: (ctx) => BudgetDialog(refresh:this.widget.refresh));
  }
  void showBudgetDeleteDialog(Budget budget) async{
    await showDialog(context: context, builder: (ctx)=> BudgetDeleteDialog(
      budget: budget,
      refresh: refresh,
    ));
  }
}

