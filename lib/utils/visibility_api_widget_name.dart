
import 'package:lead_plugin_epoint/utils/global.dart';

class VisibilityWidgetName {
  static const String LE000000 = "LE000000"; //Code KHTN
  static const String LE000001 = "LE000001"; //Tạo KHTN
  static const String LE000002 = "LE000002"; //Xem chi tiết KHTN
  static const String LE000003 = "LE000003"; //Tab thông tin chi tiết KHTN
  static const String LE000004 = "LE000004"; //Tab cơ hội bán hàng chi tiết KHTN
  static const String LE000005 = "LE000005"; //Xem chi tiết CHBH
  static const String LE000006 = "LE000006"; //Tab chăm sóc khách hàng
  static const String LE000007 = "LE000007"; //Xem chi tiết chăm sóc khách hàng
  static const String LE000008 = "LE000008"; //Chỉnh sửa Chăm sóc khách hàng
  static const String LE000009 = "LE000009"; //Tab trao đổi
  static const String LE000010 = "LE000010"; //Tab Người liên hệ
  static const String LE000011 = "LE000011"; //Tạo CHBH asisitive touch
  static const String LE000012 = "LE000012"; //Tạo CSKH
  static const String LE000013 = "LE000013"; //Xóa KHTN
  static const String LE000014 = "LE000014"; //Chỉnh sửa KHTN
}

bool checkVisibilityKey(String key) {

  bool returnCheck = false;
  try{
    final model = Global.permissionModels!.firstWhere((element) => element['widget_id'] == key);
    if(model != null){
      returnCheck = true;
    }
  }
  catch(_){}
  return returnCheck;
}