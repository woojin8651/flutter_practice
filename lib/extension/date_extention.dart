extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
        && this.day == other.day;
  }

  List<DateTime> calculateDaysInterval(DateTime endDate) {
    List<DateTime> days = [];
    for (DateTime d = this;
    d.isBefore(endDate);
    d.add(Duration(days: 1))) {
      days.add(d);
    }
    return days;
  }
}