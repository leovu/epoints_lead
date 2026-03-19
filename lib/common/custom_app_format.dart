import 'package:intl/intl.dart';

String formatDate(String input) {
  try {
    DateTime dateTime = DateTime.parse(input);
    String formatted = DateFormat('dd-MM-yyyy').format(dateTime);
    return formatted;
  } catch (_) {
    return input;
  }
}
