import 'package:intl/intl.dart';

String formatRevenue(double revenue) {
  final formatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');
  return formatter.format(revenue);
}