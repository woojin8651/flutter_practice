import 'package:flutter/material.dart';



class MonthPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width*4/5, 
        height: MediaQuery.of(context).size.width*4/5,
    );
  }
}

class MonthList extends StatelessWidget {
  const MonthList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

