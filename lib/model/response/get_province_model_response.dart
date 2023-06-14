class GetProvinceModelReponse {
  int? errorCode;
  String? errorDescription;
  List<ProvinceData>? data;

  GetProvinceModelReponse({this.errorCode, this.errorDescription, this.data});

  GetProvinceModelReponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <ProvinceData>[];
      json['Data'].forEach((v) {
        data!.add(new ProvinceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDescription'] = this.errorDescription;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
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
