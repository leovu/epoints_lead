class GetTypeWorkModelResponse {
  int errorCode;
  String errorDescription;
  List<GetTypeWorkData> data;

  GetTypeWorkModelResponse({this.errorCode, this.errorDescription, this.data});

  GetTypeWorkModelResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <GetTypeWorkData>[];
      json['Data'].forEach((v) {
        data.add(new GetTypeWorkData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDescription'] = this.errorDescription;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetTypeWorkData {
  int manageTypeWorkId;
  String manageTypeWorkName;
  String manageTypeWorkIcon;
  bool selected;

  GetTypeWorkData(
      {this.manageTypeWorkId,
      this.manageTypeWorkName,
      this.manageTypeWorkIcon,
      this.selected});

  GetTypeWorkData.fromJson(Map<String, dynamic> json) {
    manageTypeWorkId = json['manage_type_work_id'];
    manageTypeWorkName = json['manage_type_work_name'];
    manageTypeWorkIcon = json['manage_type_work_icon'];
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manage_type_work_id'] = this.manageTypeWorkId;
    data['manage_type_work_name'] = this.manageTypeWorkName;
    data['manage_type_work_icon'] = this.manageTypeWorkIcon;
    data['selected'] = this.selected;
    return data;
  }
}
