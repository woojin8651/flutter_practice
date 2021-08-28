import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_app/screens/PieChartView.dart';
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
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}

// 프레그먼트 화면
class HomeFragment extends StatefulWidget {
  const HomeFragment({Key key}) : super(key: key);

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  void refresh(){
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DailyViewPage(refresh: refresh,),
        PieChartView(refresh: refresh,)
      ],
    );
  }
}




