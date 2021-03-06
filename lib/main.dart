import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_app/extension/Colors.dart';
import 'package:flutter_practice_app/screens/Month.dart';
import 'package:flutter_practice_app/screens/loading.dart';
import 'screens/Home.dart';
import 'package:flutter_practice_app/screens/Home.dart';
import 'package:http/http.dart';
void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'Shopping Busket',
      theme: ThemeData(
        fontFamily: 'NanumGothic',
        primarySwatch: Colors.blue,
        primaryColor: AppColors.BgColorD,
        accentColor: Colors.redAccent
      ),
      home: Main(),
    );
  }
}
class Main extends StatefulWidget {
  const Main({Key key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int currIdx = 0;
  final List<Widget> Pages = [Home(),Month()];
  void onTap(int idx){
    setState(() {
      currIdx = idx;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pages[currIdx],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currIdx,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),
              label: "Home",),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today),
              label: "Month",)
        ],
        selectedItemColor: Colors.grey[700],
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
