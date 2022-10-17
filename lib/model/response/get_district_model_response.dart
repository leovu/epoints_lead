class GetDistrictModelReponse {
  int errorCode;
  String errorDescription;
  List<DistrictData> data;

  GetDistrictModelReponse({this.errorCode, this.errorDescription, this.data});

  GetDistrictModelReponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <DistrictData>[];
      json['Data'].forEach((v) {
        data.add(new DistrictData.fromJson(v));
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

class DistrictData {
  int districtid;
  String type;
  String name;
  bool selected;

  DistrictData({this.districtid, this.type, this.name});

  DistrictData.fromJson(Map<String, dynamic> json) {
    districtid = json['districtid'];
    type = json['type'];
    name = json['name'];
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['districtid'] = this.districtid;
    data['type'] = this.type;
    data['name'] = this.name;
    data['selected'] = this.selected;
    return data;
  }
}
