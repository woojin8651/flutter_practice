import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_app/screens/PieChart.dart';
import 'DailyViewPage.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);
  static const TextStyle style = TextStyle(
    fontSize: 30
  );
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Scaffold(
      body: HomeFragment(),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

// 프레그먼트 화면
class HomeFragment extends StatelessWidget {
  const HomeFragment({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DailyViewPage(),
        PieChart()
      ],
    );
  }
}




