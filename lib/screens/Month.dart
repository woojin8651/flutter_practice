import 'package:flutter/material.dart';
import 'package:flutter_practice_app/screens/MonthLineChartView.dart';
import 'package:flutter_practice_app/screens/MonthPage.dart';


class Month extends StatefulWidget {
  const Month({Key key}) : super(key: key);

  @override
  _MonthState createState() => _MonthState();
}

class _MonthState extends State<Month> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: MonthFragment(),
        backgroundColor: Colors.grey[200]
    );
  }
}
class MonthFragment extends StatelessWidget {
  const MonthFragment({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        MonthPage(),
        MonthLineChartView()
      ],
    );
  }
}

