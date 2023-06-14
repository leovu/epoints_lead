class GetListBusinessResponseModel {
  int? errorCode;
  String? errorDescription;
  List<GetListBusinessData>? data;

  GetListBusinessResponseModel(
      {this.errorCode, this.errorDescription, this.data});

  GetListBusinessResponseModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <GetListBusinessData>[];
      json['Data'].forEach((v) {
        data!.add(new GetListBusinessData.fromJson(v));
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

class GetListBusinessData {
  String? fullName;
  String? customerAvatar;
  String? customerCode;
  String? customerSourceName;
  String? email;
  String? gender;
  String? provinceName;
  String? districtName;
  String? address;
  String? customerType;

  GetListBusinessData(
      {this.fullName,
      this.customerAvatar,
      this.customerCode,
      this.customerSourceName,
      this.email,
      this.gender,
      this.provinceName,
      this.districtName,
      this.address,
      this.customerType});

  GetListBusinessData.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    customerAvatar = json['customer_avatar'];
    customerCode = json['customer_code'];
    customerSourceName = json['customer_source_name'];
    email = json['email'];
    gender = json['gender'];
    provinceName = json['province_name'];
    districtName = json['district_name'];
    address = json['address'];
    customerType = json['customer_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['customer_avatar'] = this.customerAvatar;
    data['customer_code'] = this.customerCode;
    data['customer_source_name'] = this.customerSourceName;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['province_name'] = this.provinceName;
    data['district_name'] = this.districtName;
    data['address'] = this.address;
    data['customer_type'] = this.customerType;
    return data;
  }
}
