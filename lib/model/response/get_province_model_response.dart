class GetProvinceModelReponse {
  int? errorCode;
  String? errorDescription;
  GetProvinceModel? data;

  GetProvinceModelReponse({this.errorCode, this.errorDescription, this.data});

  GetProvinceModelReponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    data = json['Data'] != null ? new GetProvinceModel.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDescription'] = this.errorDescription;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class GetProvinceModel {
  List<ProvinceData>? province;

  GetProvinceModel({this.province});

  GetProvinceModel.fromJson(Map<String, dynamic> json) {
    if (json['province'] != null) {
      province = <ProvinceData>[];
      json['province'].forEach((v) {
        province!.add(new ProvinceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.province != null) {
      data['province'] = this.province!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class ProvinceData {
  int? provinceid;
  String? type;
  String? name;
  bool? selected;

  ProvinceData({this.provinceid, this.type, this.name,  this.selected});

  ProvinceData.fromJson(Map<String, dynamic> json) {
    provinceid = json['provinceid'];
    type = json['type'];
    name = json['name'];
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provinceid'] = this.provinceid;
    data['type'] = this.type;
    data['name'] = this.name;
    data['selected'] = this.selected;
    return data;
  }
}
