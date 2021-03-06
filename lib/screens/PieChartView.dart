import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_practice_app/extension/Colors.dart';
import 'package:flutter_practice_app/model/Budget.dart';
import 'package:flutter_practice_app/screens/BudgetDialog.dart';
import 'package:flutter_practice_app/viewmodel/PieVM.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_practice_app/extension/date_extention.dart';
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
  int curIdx;
  PieVM vm;
  List<Icon> icons = [Icon(Icons.add,color: Colors.white)
    ,Icon(Icons.delete,color: Colors.white)
    ,Icon(Icons.analytics,color: Colors.white)];
  void refresh(){
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    curIdx = 0;
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
      child: piePages(),
    );
  }
  Widget piePages(){
    return Center(
      child:Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text("μμ° λΆμ",style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w100,
                  color: Colors.black),
              ),
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          body:  FutureBuilder(
            future: vm.fetchPie(_pageDate),
            builder: (ctx,snapshot){
              if(snapshot.hasData){
                return budgetChart(snapshot.data);
              }
              else if(snapshot.hasError){
                return Center(child: Text("μλ¬"));
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
    );
  }
  var _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.7,
      keepPage: false
  );

  Widget budgetChart(List<PieSet> datas){
    return PageView.builder(
        onPageChanged: (idx){
          setState(() {
            curIdx = idx;
          });
        },
        controller: _pageController,
        itemCount: datas.length,
        itemBuilder: (ctx,idx){
          return Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: vm.getTextDateList(budget:datas[idx].budget,day: _pageDate),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/2-200,
                  child: PieChart(
                    dataMap: datas[idx].PieData,
                    animationDuration: Duration(milliseconds: 1000),
                    chartRadius: MediaQuery.of(context).size.width/3.2,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 10.0,
                    chartValuesOptions: ChartValuesOptions(
                      showChartValuesInPercentage: true,
                      chartValueBackgroundColor: Colors.transparent
                    ),
                  ),
                ),
                Center(
                    child: Text("μμ°: ${datas[idx].budget.total}μ",style: styleB
                      )
                ),
                Center(
                    child: datas[idx].PieData[PieVM.PieItem] != null ?
                    Text("μ¬μ©: ${ datas[idx].PieData[PieVM.PieItem].toInt()}μ",
                    style: styleB,): Text("μ¬μ©: 0μ",style: styleB,)
                ),

              ],
            ),
          );
        });
  }
  final styleB = TextStyle(
      fontSize: 10,);
  final styleT = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.white,
      fontSize: 16.0);

  void pressFAB(int idx) async{
    switch(idx){
      case 0:
        showBudgetDialog();
        break;
      case 1:
        List<PieSet> datas = await vm.fetchPie(_pageDate);
        if(datas.isEmpty) break;
        if(await showBudgetDeleteDialog(datas[curIdx].budget)){
          if(curIdx == datas.length - 1 && curIdx != 0) curIdx--;
        }//λ ν­λͺ© μ­μ μ νμΉΈ λΉκ²¨μ§
        break;
      case 2:
        List<PieSet> datas = await vm.fetchPie(_pageDate);
        if(datas.isEmpty) break;
        showBudgetAnalyzeDialog(_pageDate,datas[curIdx].budget);
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
    log("ν΄λ¦­");
    await showDialog(context: context,
        builder: (ctx) => BudgetDialog(refresh:this.widget.refresh,pageDate: _pageDate,));
  }
  Future<bool> showBudgetDeleteDialog(Budget budget) async{
    return await showDialog(context: context, builder: (ctx)=> BudgetDeleteDialog(
      budget: budget,
      refresh: refresh,
    ));
  }
  void showBudgetAnalyzeDialog(DateTime day,Budget budget) async{
    return await showDialog(context: context,builder: (ctx) => BudgetAnalyzeDialog(
      budget: budget,
      day: day,
    ));
  }
}

