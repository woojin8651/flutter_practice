import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
class PieChart extends StatefulWidget {
  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {


  DateTime pageDate;

  void refresh(){
    setState(() {
    });
  }
@override
  void initState() {
    super.initState();
    pageDate = DateTime.now();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
}

