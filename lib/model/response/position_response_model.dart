class PositionResponseModel {
  int errorCode;
  String errorDescription;
  List<PositionData> data;

  PositionResponseModel({this.errorCode, this.errorDescription, this.data});

  PositionResponseModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <PositionData>[];
      json['Data'].forEach((v) {
        data.add(new PositionData.fromJson(v));
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

class PositionData {
  int staffTitleId;
  String staffTitleName;
  String slug;
  String staffTitleCode;
  String staffTitleDescription;
  bool selected;

  PositionData(
      {this.staffTitleId,
      this.staffTitleName,
      this.slug,
      this.staffTitleCode,
      this.staffTitleDescription});

  PositionData.fromJson(Map<String, dynamic> json) {
    staffTitleId = json['staff_title_id'];
    staffTitleName = json['staff_title_name'];
    slug = json['slug'];
    staffTitleCode = json['staff_title_code'];
    staffTitleDescription = json['staff_title_description'];
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_title_id'] = this.staffTitleId;
    data['staff_title_name'] = this.staffTitleName;
    data['slug'] = this.slug;
    data['staff_title_code'] = this.staffTitleCode;
    data['staff_title_description'] = this.staffTitleDescription;
    data['selected'] = this.selected;
    return data;
  }
}
