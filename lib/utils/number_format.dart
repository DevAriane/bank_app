import 'package:intl/intl.dart';

String formatDouble(double amount) {
  return NumberFormat('#,##0.00').format(amount);
}
