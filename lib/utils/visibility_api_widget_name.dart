
import 'package:lead_plugin_epoint/utils/global.dart';

class VisibilityWidgetName {
  static const String LE000000 = "LE000000"; //Code KHTN
  // static const String LE000001 = "LE000001"; //Tạo KHTN
  // static const String LE000002 = "LE000002"; //Xem chi tiết KHTN
  // static const String LE000003 = "LE000003"; //Tab thông tin chi tiết KHTN
  // static const String LE000004 = "LE000004"; //Tab cơ hội bán hàng chi tiết KHTN
  // static const String LE000005 = "LE000005"; //Xem chi tiết CHBH
  // static const String LE000006 = "LE000006"; //Tab chăm sóc khách hàng
  // static const String LE000007 = "LE000007"; //Xem chi tiết chăm sóc khách hàng
  // static const String LE000008 = "LE000008"; //Chỉnh sửa Chăm sóc khách hàng
  // static const String LE000009 = "LE000009"; //Tab trao đổi
  // static const String LE000010 = "LE000010"; //Tab Người liên hệ
  // static const String LE000011 = "LE000011"; //Tạo CHBH asisitive touch
  // static const String LE000012 = "LE000012"; //Tạo CSKH
  // static const String LE000013 = "LE000013"; //Xóa KHTN
  // static const String LE000014 = "LE000014"; //Chỉnh sửa KHTN
static const String LE000001 = "LE000001"; //Tạo KHTN
static const String LE000002 = "LE000002"; //Xem liên hệ khách hàng tiềm năng
static const String LE000003 = "LE000002"; //Chỉnh sửa liên hệ khách hàng khách hàng tiềm năng
static const String LE000004 = "LE000004"; //Cập nhật người giới thiệu khách hàng tiềm năng


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

String hidePhone(String? event, bool show) {
  if ((event ?? "").isEmpty) {
    return "";
  }

  int length = 3;

  if (!show) {
    if (event!.length > length) {
      return "${List.generate(event.length - length, (index) => "*").join()}${event.substring(event.length - length)}";
    }

    return List.generate(event.length, (index) => "*").join();
  }

  return event ?? "";
}

String hideEmail(String? event, bool show){
  if ((event ?? "").isEmpty) {
    return "";
  }

  if(!show){
    List<String> events = event!.split("@");
    if(events.isEmpty){
      return event;
    }

    int length = 1;

    String email = "";

    if(events.first.length > length){
      email += "${List.generate(events.first.length - length, (index) => "*").join()}${events.first.substring(events.first.length - length)}";
    }
    else{
      email += "*";
    }

    for(var i = 1; i < events.length; i++){
      email += "@${events[i]}";
    }
  print(event);
    return email;
  }

  print(event);

  return event ?? "";
}

String hideSocial(String? event, bool show){
  if ((event ?? "").isEmpty) {
    return "";
  }

  if(!show){
    return List.generate(5, (index) => "*").join();
  }

  return event ?? "";
}