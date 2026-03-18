class EditPotentialRequestModel {
  String? customerLeadCode;
  String? avatar;
  String? customerType;
  int? customerSource;
  String? fullName;
  String? taxCode;
  String? phone;
  List<String>? arrPhoneAttack;
  String? email;
  String? representative;
  String? pipelineCode;
  String? journeyCode;
  int? saleId;
  List<int?>? tagId;
  String? gender;
  String? birthday;
  int? bussinessId;
  int? employees;
  String? address;
  int? provinceId;
  int? districtId;
  int? wardId;
  String? businessClue;
  String? fanpage;
  String? zalo;
  String? contactFullName;
  String? contactPhone;
  String? contactEmail;
  String? position;
  String? contactAddress;
  int? customerGroupId;
  int? branchId;
  String? note;
  int? customerLeadReferId;
  String? website;

  EditPotentialRequestModel(
      {this.customerLeadCode,
      this.avatar,
      this.customerType,
      this.customerSource,
      this.fullName,
      this.taxCode,
      this.phone,
      this.arrPhoneAttack,
      this.email,
      this.representative,
      this.pipelineCode,
      this.journeyCode,
      this.saleId,
      this.tagId,
      this.gender,
      this.birthday,
      this.bussinessId,
      this.employees,
      this.address,
      this.provinceId,
      this.districtId,
      this.wardId,
      this.businessClue,
      this.fanpage,
      this.zalo,
      this.contactFullName,
      this.contactPhone,
      this.contactEmail,
      this.position,
      this.contactAddress,
      this.customerGroupId,
      this.branchId,
      this.note,
      this.customerLeadReferId,
      this.website});

  EditPotentialRequestModel.fromJson(Map<String, dynamic> json) {
    customerLeadCode = json['customer_lead_code'];
    avatar = json['avatar'];
    customerType = json['customer_type'];
    customerSource = json['customer_source'];
    fullName = json['full_name'];
    taxCode = json['tax_code'];
    phone = json['phone'];
    arrPhoneAttack = json['arrPhoneAttack'].cast<String>();
    email = json['email'];
    representative = json['representative'];
    pipelineCode = json['pipeline_code'];
    journeyCode = json['journey_code'];
    saleId = json['sale_id'];
    tagId = json['tag_id'].cast<int>();
    gender = json['gender'];
    birthday = json['birthday'];
    bussinessId = json['bussiness_id'];
    employees = json['employees'];
    address = json['address'];
    provinceId = json['province_id'];
    districtId = json['district_id'];
    wardId = json['ward_id'];
    businessClue = json['business_clue'];
    fanpage = json['fanpage'];
    zalo = json['zalo'];
    contactFullName = json['contact_full_name'];
    contactPhone = json['contact_phone'];
    contactEmail = json['contact_email'];
    position = json['position'];
    contactAddress = json['contact_address'];
    customerGroupId = json['customer_group_id'];
    branchId = json['branch_id'];
    note = json['note'];
    customerLeadReferId = json['customer_lead_refer_id'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_code'] = this.customerLeadCode;
    data['avatar'] = this.avatar;
    data['customer_type'] = this.customerType;
    data['customer_source'] = this.customerSource;
    data['full_name'] = this.fullName;
    data['tax_code'] = this.taxCode;
    data['phone'] = this.phone;
    data['arrPhoneAttack'] = this.arrPhoneAttack;
    data['email'] = this.email;
    data['representative'] = this.representative;
    data['pipeline_code'] = this.pipelineCode;
    data['journey_code'] = this.journeyCode;
    data['sale_id'] = this.saleId;
    data['tag_id'] = this.tagId;
    data['gender'] = this.gender;
    data['birthday'] = this.birthday;
    data['bussiness_id'] = this.bussinessId;
    data['employees'] = this.employees;
    data['address'] = this.address;
    data['province_id'] = this.provinceId;
    data['district_id'] = this.districtId;
    data['ward_id'] = this.wardId;
    data['business_clue'] = this.businessClue;
    data['fanpage'] = this.fanpage;
    data['zalo'] = this.zalo;
    data['contact_full_name'] = this.contactFullName;
    data['contact_phone'] = this.contactPhone;
    data['contact_email'] = this.contactEmail;
    data['position'] = this.position;
    data['contact_address'] = this.contactAddress;
    data['customer_group_id'] = this.customerGroupId;
    data['branch_id'] = this.branchId;
    data['note'] = this.note;
    data['customer_lead_refer_id'] = this.customerLeadReferId;
    data['website'] = this.website;
    return data;
  }
}
