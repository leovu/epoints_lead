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

String toAustraliaTime(String? dateTimeStr) {
  if (dateTimeStr == null) return "";
  final vnTime = DateTime.parse(dateTimeStr);

  final australiaTime = vnTime.add(const Duration(hours: 3));

  final day = australiaTime.day.toString().padLeft(2, '0');
  final month = australiaTime.month.toString().padLeft(2, '0');
  final year = australiaTime.year.toString();
  final hour = australiaTime.hour.toString().padLeft(2, '0');
  final minute = australiaTime.minute.toString().padLeft(2, '0');

  return "$day/$month/$year $hour:$minute";
}