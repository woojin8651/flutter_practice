
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
class Loading extends StatefulWidget {
  const Loading({Key key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    fetchData(a: 'asdf');
    //자동으로 위도 경도
  }
  void getLocation() async{
    try{
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );
      print(position);
    }catch(e) {
      print(e);
    }
  }
  void fetchData({String a}) async{
    var url = Uri.parse('https://samples.openweathermap.org/data/2.5/weather?q=London&appid=b1b15e88fa797225412429c1c50c122a1');
    var response = await http.get(url);
    var response2 = await http.post(url,);
    print('response:'+response.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: ()=>{
            getLocation()
          },
          child: Text('Get my Location'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue)
          ),
        ),
      ),
    );
  }
}