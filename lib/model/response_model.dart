class ResponseModel {
  int errorCode;
  String errorDescription;
  Map<String, dynamic> data;
  List<dynamic> datas;
  bool success;
  String url;

  ResponseModel({this.errorCode, this.errorDescription, this.data, this.success = false, this.url = ""});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = (json['ErrorDescription']??"").toString();
    url = (json['url']??"").toString();
    data = {};
    datas = [];
    if(json['Data'] != null){
      if(json['Data'] is Map<String, dynamic>)
        data = json['Data'];
      else if(json['Data'] is List<dynamic>)
        datas = json['Data'];
    }
    success = errorCode == 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDescription'] = this.errorDescription;
    if (this.data != null) {
      data['Data'] = this.data;
    }
    data['url'] = this.url;
    return data;
  }
}