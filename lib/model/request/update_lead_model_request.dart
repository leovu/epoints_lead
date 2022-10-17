class UpdateLeadRequestModel {
  String customerLeadCode;
  String customerType;
  String fullName;
  int phone;
  int customerSource;
  String pipelineCode;
  String journeyCode;
  String avatar;
  String provinceId;
  String districtId;
  String address;
  String saleId;
  String businessClue;
  String zalo;

  UpdateLeadRequestModel(
      {this.customerLeadCode,
      this.customerType,
      this.fullName,
      this.phone,
      this.customerSource,
      this.pipelineCode,
      this.journeyCode,
      this.avatar,
      this.provinceId,
      this.districtId,
      this.address,
      this.saleId,
      this.businessClue,
      this.zalo});

  UpdateLeadRequestModel.fromJson(Map<String, dynamic> json) {
    customerLeadCode = json['customer_lead_code'];
    customerType = json['customer_type'];
    fullName = json['full_name'];
    phone = json['phone'];
    customerSource = json['customer_source'];
    pipelineCode = json['pipeline_code'];
    journeyCode = json['journey_code'];
    avatar = json['avatar'];
    provinceId = json['province_id'];
    districtId = json['district_id'];
    address = json['address'];
    saleId = json['sale_id'];
    businessClue = json['business_clue'];
    zalo = json['zalo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_code'] = this.customerLeadCode;
    data['customer_type'] = this.customerType;
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['customer_source'] = this.customerSource;
    data['pipeline_code'] = this.pipelineCode;
    data['journey_code'] = this.journeyCode;
    data['avatar'] = this.avatar;
    data['province_id'] = this.provinceId;
    data['district_id'] = this.districtId;
    data['address'] = this.address;
    data['sale_id'] = this.saleId;
    data['business_clue'] = this.businessClue;
    data['zalo'] = this.zalo;
    return data;
  }
}
