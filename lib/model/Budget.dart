class Budget{
  static const String sql_table="budget";
  static const String sql_id="id";
  static const String sql_total="total";
  static const String sql_repeat="repeat";
  static const String sql_repeatDay="repeatDay";
  static const String sql_repeatP="repeatP";
  static const String sql_stDay="stDay";
  static const String sql_edDay="edDay";

  static const String repeatMonth = "month";
  static const String repeatYear = "year";
  static const int modeUnRepeat = 0;
  static const int modeRepeat = 1;
  static const int defaultRepeatDay = 1;
  static const String defaultRepeatP = repeatMonth; //default month
  static const String defaultDay = "0000-00-00";
  String id; //고유 아이디
  int total; //기간 예산안
  int repeat; //반복형인지 0이면 반복x 1이면 반복d
  int repeatDay; //반복형 일경우 날짜
  String repeatP; //반복기간
  //반복형이 아닐때
  String stDay; //시작날짜
  String edDay; // 끝날짜
  Budget({
    this.id,
    this.total,
    this.repeat,
    this.repeatDay,
    this.repeatP,
    this.stDay,
    this.edDay,
  });

  Map<String,dynamic> toMap(){
    return{
      sql_id:id,
      sql_total:total,
      sql_repeat:repeat,
      sql_repeatDay:repeatDay,
      sql_repeatP:repeatP,
      sql_stDay:stDay,
      sql_edDay:edDay
    };
  }
}