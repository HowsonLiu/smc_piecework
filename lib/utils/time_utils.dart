import 'package:intl/intl.dart';

String getTimeStr(DateTime? date) {
  if (date == null) return '未知时间';
  var now = DateTime.now();
  var defaultFormatStr = 'MM-dd hh:mm';
  if (now.year - date.year > 0) {
    defaultFormatStr = 'yyyy-MM-dd hh:mm';
  }

  final DateFormat format = DateFormat(defaultFormatStr);
  return format.format(date);
}
