
class DetailPotentialModelResponse {
  int errorCode;
  String errorDescription;
  DetailPotentialData data;

  DetailPotentialModelResponse(
      {this.errorCode, this.errorDescription, this.data});

  DetailPotentialModelResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    data = json['Data'] != null ? new DetailPotentialData.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDescription'] = this.errorDescription;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class DetailPotentialData {
  String fullName;
  String phone;
  String customerLeadCode;
  int customerSource;
  String customerSourceName;
  String customerType;
  String pipelineName;
  String pipelineCode;
  String journeyName;
  String journeyCode;
  String email;
  String gender;
  int provinceId;
  int districtId;
  String provinceType;
  String provinceName;
  String districtType;
  String districtName;
  String address;
  String zalo;
  String fanpage;
  int saleId;
  String saleName;
  int isConvert;
  String businessClue;
  String businessClueName;
  int timeRevokeLead;
  String dateRevoke;
  String allocationDate;
  List<JourneyTrackingPotential> journeyTracking;

  DetailPotentialData(
      {this.fullName,
      this.phone,
      this.customerLeadCode,
      this.customerSource,
      this.customerSourceName,
      this.customerType,
      this.pipelineName,
      this.pipelineCode,
      this.journeyName,
      this.journeyCode,
      this.email,
      this.gender,
      this.provinceId,
      this.districtId,
      this.provinceType,
      this.provinceName,
      this.districtType,
      this.districtName,
      this.address,
      this.zalo,
      this.fanpage,
      this.saleId,
      this.saleName,
      this.isConvert,
      this.businessClue,
      this.businessClueName,
      this.timeRevokeLead,
      this.dateRevoke,
      this.allocationDate,
      this.journeyTracking});

  DetailPotentialData.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    phone = json['phone'];
    customerLeadCode = json['customer_lead_code'];
    customerSource = json['customer_source'];
    customerSourceName = json['customer_source_name'];
    customerType = json['customer_type'];
    pipelineName = json['pipeline_name'];
    pipelineCode = json['pipeline_code'];
    journeyName = json['journey_name'];
    journeyCode = json['journey_code'];
    email = json['email'];
    gender = json['gender'];
    provinceId = json['province_id'];
    districtId = json['district_id'];
    provinceType = json['province_type'];
    provinceName = json['province_name'];
    districtType = json['district_type'];
    districtName = json['district_name'];
    address = json['address'];
    zalo = json['zalo'];
    fanpage = json['fanpage'];
    saleId = json['sale_id'];
    saleName = json['sale_name'];
    isConvert = json['is_convert'];
    businessClue = json['business_clue'];
    businessClueName = json['business_clue_name'];
    timeRevokeLead = json['time_revoke_lead'];
    dateRevoke = json['date_revoke'];
    allocationDate = json['allocation_date'];
    if (json['journey_tracking'] != null) {
      journeyTracking = <JourneyTrackingPotential>[];
      json['journey_tracking'].forEach((v) {
        journeyTracking.add(new JourneyTrackingPotential.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['customer_lead_code'] = this.customerLeadCode;
    data['customer_source'] = this.customerSource;
    data['customer_source_name'] = this.customerSourceName;
    data['customer_type'] = this.customerType;
    data['pipeline_name'] = this.pipelineName;
    data['pipeline_code'] = this.pipelineCode;
    data['journey_name'] = this.journeyName;
    data['journey_code'] = this.journeyCode;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['province_id'] = this.provinceId;
    data['district_id'] = this.districtId;
    data['province_type'] = this.provinceType;
    data['province_name'] = this.provinceName;
    data['district_type'] = this.districtType;
    data['district_name'] = this.districtName;
    data['address'] = this.address;
    data['zalo'] = this.zalo;
    data['fanpage'] = this.fanpage;
    data['sale_id'] = this.saleId;
    data['sale_name'] = this.saleName;
    data['is_convert'] = this.isConvert;
    data['business_clue'] = this.businessClue;
    data['business_clue_name'] = this.businessClueName;
    data['time_revoke_lead'] = this.timeRevokeLead;
    data['date_revoke'] = this.dateRevoke;
    data['allocation_date'] = this.allocationDate;
    if (this.journeyTracking != null) {
      data['journey_tracking'] =
          this.journeyTracking.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JourneyTrackingPotential {
  String journeyCode;
  int journeyId;
  String journeyName;
  int pipelineId;
  String pipelineCode;
  bool check;

  JourneyTrackingPotential(
      {this.journeyCode,
      this.journeyId,
      this.journeyName,
      this.pipelineId,
      this.pipelineCode,
      this.check});

  JourneyTrackingPotential.fromJson(Map<String, dynamic> json) {
    journeyCode = json['journey_code'];
    journeyId = json['journey_id'];
    journeyName = json['journey_name'];
    pipelineId = json['pipeline_id'];
    pipelineCode = json['pipeline_code'];
    check = json['check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['journey_code'] = this.journeyCode;
    data['journey_id'] = this.journeyId;
    data['journey_name'] = this.journeyName;
    data['pipeline_id'] = this.pipelineId;
    data['pipeline_code'] = this.pipelineCode;
    data['check'] = this.check;
    return data;
  }
}