
import 'dart:ui';
import 'package:http/http.dart' as http;

class Global {

  static bool validateCreateDate = true;

  static bool validateAllocateDate = true;

  static bool validateHistoryCareDate = true;

  static bool validateWorkScheduleDate = true;

  static Function? createJob;

  static late Function editJob;

  static Function? openDetailDeal;

  static Function? createDeal;

  static String domain = '';
  static String brandCode = '';
  static String asscessToken = '';
  static Locale? locale;

  static http.Client client = http.Client();

  // static List<String>? permission;

  static List<Map<String, dynamic>>? permissionModels = [];

  static Function(Map<String,dynamic>)? callHotline; 

}