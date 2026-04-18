class WardNewResponseModel {
  List<WardModel>? data;

  WardNewResponseModel({this.data});

  WardNewResponseModel.fromJson(List<dynamic>? json) {
    if (json != null) {
      data = <WardModel>[];
      json.forEach((v) {
        data!.add(new WardModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WardModel {
  int? wardId;
  String? name;
  bool? selected;

  WardModel({this.wardId, this.name});

  WardModel.fromJson(Map<String, dynamic> json) {
    wardId = json['ward_id'] ?? json['geo_ward_id'];
    name = json['name'];
    selected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ward_id'] = this.wardId;
    data['name'] = this.name;
    return data;
  }
}
