import 'package:intl/intl.dart';

String getTimeStr(DateTime? date) {
  if (date == null) return '未知时间';
  var now = DateTime.now();
  var defaultFormatStr = 'MM月dd日hh时mm分';
  if (now.year - date.year > 0) {
    defaultFormatStr = 'yyyy年MM月dd日hh时mm分';
  }

  final DateFormat format = DateFormat(defaultFormatStr);
  return format.format(date);
}
