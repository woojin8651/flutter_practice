import 'package:flutter/material.dart';

class MonthLineChartView extends StatelessWidget {
  const MonthLineChartView({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/2,
    );
  }


}
