import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

DateTime convertToWAT(DateTime dateTime) {
  // WAT is UTC+1, so we add 1 hour to UTC time
  return dateTime.toUtc().add(const Duration(hours: 1));
}