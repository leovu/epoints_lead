class AddLeadModelRequest {
  String avatar;
  String customerType;
  String fullName;
  String phone;
  int customerSource;
  String pipelineCode;
  String journeyCode;
  String address;
  int provinceId;
  int districtId;
  int saleId;
  String businessClue;
  String fanpage;
  String zalo;
  String gender;
  String email;

  AddLeadModelRequest(
      {this.avatar,
      this.customerType,
      this.fullName,
      this.phone,
      this.customerSource,
      this.pipelineCode,
      this.journeyCode,
      this.address,
      this.provinceId,
      this.districtId,
      this.saleId,
      this.businessClue,
      this.fanpage,
      this.zalo,
      this.gender,
      this.email});

  AddLeadModelRequest.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    customerType = json['customer_type'];
    fullName = json['full_name'];
    phone = json['phone'];
    customerSource = json['customer_source'];
    pipelineCode = json['pipeline_code'];
    journeyCode = json['journey_code'];
    address = json['address'];
    provinceId = json['province_id'];
    districtId = json['district_id'];
    saleId = json['sale_id'];
    businessClue = json['business_clue'];
    fanpage = json['fanpage'];
    zalo = json['zalo'];
    gender = json['gender'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['customer_type'] = this.customerType;
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['customer_source'] = this.customerSource;
    data['pipeline_code'] = this.pipelineCode;
    data['journey_code'] = this.journeyCode;
    data['address'] = this.address;
    data['province_id'] = this.provinceId;
    data['district_id'] = this.districtId;
    data['sale_id'] = this.saleId;
    data['business_clue'] = this.businessClue;
    data['fanpage'] = this.fanpage;
    data['zalo'] = this.zalo;
    data['gender'] = this.gender;
    data['email'] = this.email;
    return data;
  }
}
