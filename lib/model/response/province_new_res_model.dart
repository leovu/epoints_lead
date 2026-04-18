class ProvinceNewResponseModel {
  List<ProvinceModel>? data;

  ProvinceNewResponseModel({this.data});

  ProvinceNewResponseModel.fromJson(List<dynamic>? json) {
    if (json != null) {
      data = <ProvinceModel>[];
      json.forEach((v) {
        data!.add(new ProvinceModel.fromJson(v));
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

class ProvinceModel {
  int? provinceid;
  String? name;
  bool selected;

  ProvinceModel({
    this.provinceid,
    this.name,
    this.selected = false,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      provinceid: json['provinceid'] ?? json['geo_province_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provinceid': provinceid,
      'name': name,
    };
  }
}
