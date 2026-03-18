class CustomerCreateAddressModel {
  ProvinceModel? provinceModel;
  DistrictModel? districtModel;
  WardModel? wardModel;
  String? street;

  CustomerCreateAddressModel(
      {this.provinceModel, this.districtModel, this.wardModel, this.street});
}


class ProvinceResponseModel {
  List<ProvinceModel>? data;

  ProvinceResponseModel({this.data});

  ProvinceResponseModel.fromJson(List<dynamic>? json) {
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
  bool? selected;

  ProvinceModel({this.provinceid, this.name});

  ProvinceModel.fromJson(Map<String, dynamic> json) {
    provinceid = json['provinceid'];
    name = json['name'];
    selected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provinceid'] = this.provinceid;
    data['name'] = this.name;
    return data;
  }
}

class DistrictResponseModel {
  List<DistrictModel>? data;

  DistrictResponseModel({this.data});

  DistrictResponseModel.fromJson(List<dynamic>? json) {
    if (json != null) {
      data = <DistrictModel>[];
      json.forEach((v) {
        data!.add(new DistrictModel.fromJson(v));
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

class DistrictModel {
  int? districtid;
  String? name;
  bool? selected;

  DistrictModel({this.districtid, this.name});

  DistrictModel.fromJson(Map<String, dynamic> json) {
    districtid = json['districtid'];
    name = json['name'];
    selected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['districtid'] = this.districtid;
    data['name'] = this.name;
    return data;
  }
}

class WardResponseModel {
  List<WardModel>? data;

  WardResponseModel({this.data});

  WardResponseModel.fromJson(List<dynamic>? json) {
    if (json!= null) {
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
    wardId = json['ward_id'];
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