import 'package:intl/intl.dart';

String formatDateHour(int date) {
  final dateTime = DateTime.fromMicrosecondsSinceEpoch(date * 1000);
  final format = DateFormat('d MMM yyyy hh:mm a');
  return format.format(dateTime);
}

String formatDateHourSimple(int date) {
  final format = DateFormat('MM.dd.yyyy hh:mm a');
  if (date != null) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(date * 1000);
    return format.format(dateTime);
  }
  return format.format(DateTime.now());
}

String formatDate(int date) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(date);
  final format = DateFormat('dd MMM yyyy, hh:mm a');
  return format.format(dateTime);
}
