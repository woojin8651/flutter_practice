import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_practice_app/extension/Colors.dart';
import 'package:flutter_practice_app/model/Budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_app/extension/date_extention.dart';
import 'package:flutter_practice_app/model/Unit.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_practice_app/viewmodel/PieVM.dart';
class BudgetDialog extends StatefulWidget {
  Function refresh;
  BudgetDialog({this.refresh});
  @override
  _BudgetDialogState createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<BudgetDialog> {

  String _stDay;
  String _edDay;
  String _repeatP;
  int _repeatDay ;
  int _repeatMode;
  PieVM vm ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stDay = Budget.defaultDay;
    _edDay= Budget.defaultDay;
    _repeatP = Budget.defaultRepeatP;
    _repeatDay = Budget.defaultRepeatDay;
    _repeatMode = Budget.modeUnRepeat;
    vm = PieVM.instance();
  }
  void setMode(int mode){
    setState(() {
      _stDay = Budget.defaultDay;
      _edDay= Budget.defaultDay;
      _repeatP = Budget.defaultRepeatP;
      _repeatDay = Budget.defaultRepeatDay;
      _repeatMode = mode;
    });
  }
  void setStEd(String st,String ed){
    setState(() {
      _stDay = st;
      _edDay = ed;
    });
  }
  final textDecoration = (String hint) => InputDecoration(
      border: OutlineInputBorder(),
      labelText: hint,
    suffixText: "원"
  );
  final stStyle = TextStyle(

    color: Colors.black,
  );
  final edStyle = TextStyle(

    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      content: content(),
      actions: [
        TextButton(onPressed: () => onPressedConfirm(context), child: Text("확인")),
        TextButton(onPressed: () => onPressedCancel(context), child: Text("취소"))
      ],
    );
  }

  final TotalTec = TextEditingController();

  Widget content(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Center(
        child: Container(
          padding: EdgeInsets.only(top: 20.0),
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: textDecoration("예산 금액"),
                  keyboardType: TextInputType.number,
                  controller: TotalTec,
                ),
              ),
              Column(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<int>(
                      title: Text("기간 설정"),
                      value: Budget.modeUnRepeat,
                      groupValue: _repeatMode,
                      onChanged: setMode,),
                  RadioListTile<int>(title: Text("반복 설정"),
                      value: Budget.modeRepeat,
                      groupValue: _repeatMode,
                      onChanged: setMode),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child:
                Center(
                    child: Container(
                        width: MediaQuery.of(context).size.width*2/3,
                        height:MediaQuery.of(context).size.width*2/3,
                        child: budgetFrame(_repeatMode))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget budgetFrame(int repeatMode){
    if(repeatMode == Budget.modeUnRepeat){
      return Flex(
        direction: Axis.vertical,
        children: [
          SfDateRangePicker(
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.range,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
              PickerDateRange range =  args.value;
              setStEd(Formats.dfm.format(range.startDate),
                  Formats.dfm.format(range.endDate));
            },
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(_stDay,
                style: stStyle,),
                Text("~"),
                Text(_edDay,
                style: edStyle,)
              ],
            ),
          )
        ],
      );
    }
    else if(repeatMode == Budget.modeRepeat){return Text("미완");

    }
    else return Text("반복 모드 오류");
  }
  void onPressedConfirm(BuildContext ctx) async{
    if(_repeatMode == 0){
      if(_stDay == Budget.defaultDay || _edDay == Budget.defaultDay) return;
      if(TotalTec.text.isEmpty) return;
      await vm.insertBudget(Budget(
        total: int.parse(TotalTec.text),
        repeat: _repeatMode,
        repeatDay: _repeatDay,
        repeatP: _repeatP,
        stDay: _stDay,
        edDay: _edDay
      ));
      this.widget.refresh();
      Navigator.pop(ctx);
    }
    else if(_repeatMode == 1){

    }
  }
  void onPressedCancel(BuildContext ctx){
    Navigator.pop(ctx);
  }

}

class BudgetDeleteDialog extends StatelessWidget {
  BudgetDeleteDialog({@required this.budget,@required this.refresh,this.callback});
  Function refresh;
  Function callback;
  Budget budget;
  PieVM vm = PieVM.instance();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      content: Text("해당 예산을 삭제 하겠습니까?"),
      actions: [
        TextButton(onPressed: () => onPressedDelete(context), child: Text("확인")),
        TextButton(onPressed: () => onPressedCancel(context), child: Text("취소"))
      ],
    );
  }
  void onPressedDelete(BuildContext ctx) async{
    await vm.deleteBudget(budget);
    this.refresh();
    Navigator.pop(ctx,true);
  }
  void onPressedCancel(BuildContext ctx){
    Navigator.pop(ctx,false);
  }
}

class BudgetAnalyzeDialog extends StatelessWidget {
  PieVM vm = PieVM.instance();
  DateTime day;
  Budget budget;

  BudgetAnalyzeDialog({@required this.day,@required this.budget});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      title: Center(
        child: Text("소비 분석"),
      ),
      content: content(),
      actions: [
        TextButton(onPressed: () => onPressedCancel(context), child: Text("닫기"))
      ],
    );
  }
  void onPressedCancel(BuildContext ctx){
    Navigator.pop(ctx);
  }

  Widget content() {
    return FutureBuilder(
      future: vm.fetchRadar(day, budget),
        builder: (cxt,snapshot){
        if(snapshot.hasData){
          return Container(
              width: 400,
              height: 400,
              child: RadarChart(
                RadarChartData(

                  dataSets: snapshot.data,
                  radarBackgroundColor: Colors.transparent,
                  borderData: FlBorderData(show: false),
                  radarBorderData: const BorderSide(color: Colors.transparent),
                  tickBorderData: const BorderSide(color: Colors.transparent),
                  gridBorderData:  BorderSide(color: Colors.grey.withOpacity(0.5)),
                  tickCount: 2,
                  ticksTextStyle: TextStyle(
                    fontSize: 10
                  ),
                  getTitle: (idx){
                    switch(idx){
                      case 0:
                        return "기타";
                      case 1:
                        return "식재료";
                      case 2:
                        return "부가비용";
                      case 3:
                        return "유흥비";
                      case 4:
                        return "장비";
                      default:
                        return '';
                    }
                  }
                ),
                swapAnimationCurve: Curves.linear,
                swapAnimationDuration: Duration(milliseconds: 1000),
              )
            );
        }else if(snapshot.hasError){
          return Center(
            child: Text("에러"),
          );
        }
        return Center(
          child: SizedBox(
            child: CircularProgressIndicator(),
            height: 100,
            width: 100,
          ),
        );
      });
  }
}
//vertices: [
//                     PreferredSize(child:  Text("기타"),
//                         preferredSize: Size.square(10)),
//                     PreferredSize(child:  Text("식재료"),
//                         preferredSize: Size.square(10)),
//                     PreferredSize(child:  Text("부가비용"),
//                         preferredSize: Size.square(10)),
//                     PreferredSize(child:  Text("유흥비"),
//                         preferredSize: Size.square(10)),
//                     PreferredSize(child:  Text("장비"),
//                         preferredSize: Size.square(10)),
//                   ]
//  static const int U_Undefine = 0; // 기타
//   static const int U_FIngredident = 1; // 식재료
//   static const int U_additional = 2;// 부가비용
//   static const int U_Entertainment = 3;// 유흥비
//   static const int U_Equipment = 4;// 장비
//Budget({
//     this.id,
//     this.total,
//     this.repeat,
//     this.repeatDay,
//     this.repeatP,
//     this.stDay,
//     this.edDay,
//   });