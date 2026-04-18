import 'package:intl/intl.dart';

class CustomAppFormat {
  static String formatDate(String input) {
    try {
      DateTime date = DateTime.parse(input);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return input;
    }
  }
}
