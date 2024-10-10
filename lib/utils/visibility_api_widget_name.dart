
import 'package:lead_plugin_epoint/utils/global.dart';

class VisibilityWidgetName {
  static const String CM000000 = "CM000000"; //Khóa/bật chức năng khách hàng
  static const String CM000001 = "CM000001"; //Tạo khách hàng
  static const String CM000002 = "CM000002"; //Xem chi tiết khách hàng
  static const String CM000003 = "CM000003"; //Chỉnh sửa khách hàng
  static const String CM000004 = "CM000004"; //Xem liên hệ khách hàng
  static const String CM000005 = "CM000005"; //Chỉnh sửa liên hệ khách hàng
  static const String CM000006 = "CM000006"; //Cập nhật người giới thiệu khách hàng
  static const String CM000007 = "CM000007"; //Xem thông tin giá trị đơn hàng
  static const String CM000008 = "CM000008"; //Call hot line
  static const String OD000000 = "OD000000"; //Khóa/bật chức năng đơn hàng
  static const String OD000001 = "OD000001"; //Tạo đơn hàng
  static const String OD000002 = "OD000002"; //Xem chi tiết đơn hàng
  static const String OD000004 = "OD000004"; //Thanh toán đơn hàng
  static const String OD000005 = "OD000005"; //Xem danh sách sản phẩm
  static const String OD000007 = "OD000007"; //Xem hình ảnh đơn hàng
  static const String OD000008 = "OD000008"; //Chỉnh sửa và upload hình ảnh đơn hàng
  static const String OD000009 = "OD000009"; //Xem thông tin giá trị đơn hàng
  static const String RP000000 = "RP000000"; //Khóa/bật chức năng báo cáo
  static const String RP000001 = "RP000001"; //Xem doanh thu bán hàng
  static const String RP000002 = "RP000002"; //Xem hoa hồng
  static const String RP000003 = "RP000003"; //Xem tồn kho
  static const String TK000000 = "TK000000"; //Ticket
  static const String TK000001 = "TK000001"; //Ticket của tôi
  static const String TK000002 = "TK000002"; //Ticket chưa phân công
  static const String TK000003 = "TK000003"; //Ticket chưa hoàn thành
  static const String TK000004 = "TK000004"; //Danh sách ticket
  static const String WK000000 = "WK000000"; //Công việc
  static const String WK000001 = "WK000001"; //Việc của tôi
  static const String WK000002 = "WK000002"; //Phê duyệt công việc
  static const String WK000003 = "WK000003"; //Tạo công việc
  static const String WK000004 = "WK000004"; //Tổng quan công việc
  static const String WK000005 = "WK000005"; //Danh sách công việc
  static const String WK000006 = "WK000006"; //Công việc tôi giao
  static const String WK000007 = "WK000007"; //Xem nhắc nhở
  static const String WK000008 = "WK000008"; //Danh sách dự án
  static const String TI000000 = "TI000000"; //Chấm công
  static const String TI000001 = "TI000001"; //Lịch sử chấm công
  static const String CH000000 = "CH000000"; //Chat
  static const String SY000000 = "SY000000"; //Khảo sát
  static const String AP000000 = "AP000000"; //Đơn phép của tôi
  static const String AP000001 = "AP000001"; //Tạo đơn phép
  static const String AP000002 = "AP000002"; //Phê duyệt đơn phép
  static const String BK000000 = "BK000000"; //Tạo lịch hẹn
  static const String BK000001 = "BK000001"; //Danh sách lịch hẹn
  static const String DO000000 = "DO000000"; //Quản lý tài liệu
  static const String WA000000 = "WA000000"; //Bảo hành
  static const String WA000001 = "WA000001"; //Quét mã bảo hành
  static const String MA000000 = "MA000000"; //Bảo trì
  static const String CH000001 = "CH000001"; //Chat Hub
  static const String LE000000 = "LE000000"; //Khách hàng tiềm năng
  static const String LE000001 = "LE000001"; //Thêm khách hàng tiềm năng
  static const String LE000002 = "LE000002"; //Xem liên hệ khách hàng tiềm năng
  static const String LE000003 = "LE000003"; //Chỉnh sửa liên hệ khách hàng khách hàng tiềm năng
  static const String LE000004 = "LE000004"; //Cập nhật người giới thiệu khách hàng tiềm năng
  static const String DE000000 = "DE000000"; //Cơ hội bán hàng
  static const String PR000000 = "PR000000"; //Quản lý dự án
  static const String PR000001 = "PR000001"; //Thêm dự án


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