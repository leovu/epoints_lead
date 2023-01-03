class GetStatusWorkResponseModel {
  int errorCode;
  String errorDescription;
  List<GetStatusWorkData> data;

  GetStatusWorkResponseModel(
      {this.errorCode, this.errorDescription, this.data});

  GetStatusWorkResponseModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <GetStatusWorkData>[];
      json['Data'].forEach((v) {
        data.add(new GetStatusWorkData.fromJson(v));
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

class GetStatusWorkData {
  int manageStatusId;
  int manageStatusValue;
  String manageStatusName;
  String manageStatusColor;
  bool selected;

  GetStatusWorkData(
      {this.manageStatusId,
      this.manageStatusValue,
      this.manageStatusName,
      this.manageStatusColor,
      this.selected});

  GetStatusWorkData.fromJson(Map<String, dynamic> json) {
    manageStatusId = json['manage_status_id'];
    manageStatusValue = json['manage_status_value'];
    manageStatusName = json['manage_status_name'];
    manageStatusColor = json['manage_status_color'];
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manage_status_id'] = this.manageStatusId;
    data['manage_status_value'] = this.manageStatusValue;
    data['manage_status_name'] = this.manageStatusName;
    data['manage_status_color'] = this.manageStatusColor;
    data['selected'] = this.selected;
    return data;
  }
}
