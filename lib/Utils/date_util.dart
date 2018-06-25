class DateUtil {

  static formatDateSimple(DateTime dt) {
    StringBuffer sb = new StringBuffer();
    sb.write(dt.year.toString());
    sb.write(dt.month.toString().padLeft(2, '0'));
    sb.write(dt.day.toString().padLeft(2, '0'));
    return sb.toString();
  }

  static formatDate(int time) {
    var dt = new DateTime.fromMillisecondsSinceEpoch(time);

    StringBuffer sb = new StringBuffer();
    sb.write(dt.year);
    sb.write('-');
    sb.write(dt.month.toString().padLeft(2, '0'));
    sb.write('-');
    sb.write(dt.day.toString().padLeft(2, '0'));
    sb.write(' ');
    sb.write(dt.hour.toString().padLeft(2, '0'));
    sb.write(':');
    sb.write(dt.minute.toString().padLeft(2, '0'));
    sb.write(':');
    sb.write(dt.second.toString().padLeft(2, '0'));
    return sb.toString();
  }

  static formatDateWithWeek(DateTime dt) {
    StringBuffer sb = new StringBuffer();
    sb.write(dt.year.toString());
    sb.write('年');
    sb.write(dt.month.toString());
    sb.write('月');
    sb.write(dt.day.toString());
    sb.write('日');
    sb.write('   ');
    switch (dt.weekday) {
      case DateTime.monday:
        sb.write('星期一');
        break;
      case DateTime.tuesday:
        sb.write('星期二');
        break;
      case DateTime.wednesday:
        sb.write('星期三');
        break;
      case DateTime.thursday:
        sb.write('星期四');
        break;
      case DateTime.friday:
        sb.write('星期五');
        break;
      case DateTime.saturday:
        sb.write('星期六');
        break;
      case DateTime.sunday:
        sb.write('星期天');
        break;
    }

    return sb.toString();
  }
}
