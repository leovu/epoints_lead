
import 'dart:ui';
import 'package:http/http.dart' as http;

class Global {

  static bool validateCreateDate = true;

  static bool validateAllocateDate = true;

  static bool validateHistoryCareDate = true;

  static bool validateWorkScheduleDate = true;

  static Function?  createJob;

  static Function(Map<String,dynamic>)?  createCare;

  static Function(int)? editJob;

  static Function(int)? negativeDetailPrefer;

  static Function(String)? openDetailDeal;

  static Function(Map<String,dynamic>)? createDeal;

  static Function(Map<String,dynamic>)? showDetailDeal;

  static String domain = '';
  static String brandCode = '';
  static String asscessToken = '';
  static Locale? locale;

  static http.Client client = http.Client();

  // static List<String>? permission;

  static List<Map<String, dynamic>>? permissionModels = [];

  static Function(Map<String,dynamic>)? callHotline; 

}