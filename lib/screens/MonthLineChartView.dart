
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_app/extension/Colors.dart';
import 'package:flutter_practice_app/model/MonthData.dart';
import 'package:flutter_practice_app/viewmodel/MonthPageVM.dart';

class MonthLineChartView extends StatelessWidget {
  const MonthLineChartView({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text("월간 소비 그래프",style: const TextStyle(color: Color(0xff000000), fontSize: 20)),
            Container(
              child: Chart(),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/2,
            padding: EdgeInsets.all(30),
          )
          ],
        )
      );
  }
}
class Chart extends StatelessWidget {

  MonthPageVM vm = MonthPageVM.instance();

  List<Color> gradientColors = [
    AppColors.BgColorB,
    AppColors.BgColorD
  ];

  final graphTileStyle = const TextStyle(color: Color(0x71252525), fontWeight: FontWeight.bold, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: vm.getMonthData(),
        builder: (ctx,snap){
            if(snap.hasData){
              return LineChart(
                getData(snap.data),
                swapAnimationDuration: Duration(milliseconds: 150),
                swapAnimationCurve: Curves.linear,
              );
            }
            else if(snap.hasError)
              return Text("저장된 데이터가 없습니다.");
            return Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 100,
                width: 100,
              ),
            );
        });
  }
  LineChartData getData(List<MonthData> monthDatas){
    double monMax = monthDatas.fold(0.0, (p, e) => max<double>(p,e.maxDateSum().toDouble()));
    return LineChartData(
      gridData: FlGridData(
        horizontalInterval:monMax >500000? monMax/4 :50000,
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value){
          return FlLine(
            color: const Color(0x9e6f6f6f),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0x9e6f6f6f),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles:  SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize:  22,
          interval: 1/12,
          getTextStyles: (context, value) => graphTileStyle,
          getTitles: (value){
            return "${((value - value.toInt())*13).toInt()}월";
          }, //202008 , 2020101
          margin: 8
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: monMax >500000? monMax/5 :50000,
          reservedSize: 32,
          margin: 8,
          getTextStyles: (context, value) => graphTileStyle
        ),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: (monthDatas.first?.year+monthDatas.first?.month/12.0).toDouble() ?? 0.0,
      maxX: (monthDatas.last?.year+monthDatas.last?.month/12.0+(1/13.0)).toDouble() ?? 0.0,
      minY: 0,
      maxY: monthDatas.fold(0.0, (p1, e1) => max<double>(p1,e1.maxDateSum().toDouble())) + 100.0,
      lineBarsData: [
        LineChartBarData(
        spots:makeSpot(monthDatas),
        isCurved: true,
        preventCurveOverShooting: true,
        colors: gradientColors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false
        ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color)=> color.withOpacity(0.3)).toList(),
          )
      )]
    );
  }
  List<FlSpot> makeSpot(List<MonthData> monthdatas){
    List<FlSpot> ret = [];
    monthdatas.forEach((month) {
      month.dateSum.forEach((date) {
        ret.add(FlSpot(
            (month.year+month.month/12.0).toDouble()+(date.day/(32.0*12.0)),
            date.cost.toDouble()));
      });
    });
    return ret;
  }
}

