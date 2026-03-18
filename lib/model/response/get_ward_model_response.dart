class GetWardModelReponse {
  int? errorCode;
  String? errorDescription;
  List<WardData>? data;

  GetWardModelReponse({this.errorCode, this.errorDescription, this.data});

  GetWardModelReponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <WardData>[];
      json['Data'].forEach((v) {
        data!.add( WardData.fromJson(v));
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

class WardData {
  int? wardid;
  String? type;
  String? name;
  bool? selected;

  WardData({this.wardid, this.type, this.name,  this.selected});

  WardData.fromJson(Map<String, dynamic> json) {
    wardid = json['ward_id'];
    type = json['type'];
    name = json['name'];
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ward_id'] = this.wardid;
    data['type'] = this.type;
    data['name'] = this.name;
    data['selected'] = this.selected;
    return data;
  }
}
