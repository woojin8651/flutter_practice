import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'package:flutter_practice_app/screens/home.dart';
import 'package:http/http.dart';
void main()=>runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'Shopping Busket',
      initialRoute: '/',
      routes: {
        '/': (context)=>Home(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
