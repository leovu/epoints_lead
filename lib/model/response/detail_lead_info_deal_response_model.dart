class DetailLeadInfoDealResponseModel {
  int? errorCode;
  String? errorDescription;
  List<DetailLeadInfoDealData>? data;

  DetailLeadInfoDealResponseModel(
      {this.errorCode, this.errorDescription, this.data});

  DetailLeadInfoDealResponseModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <DetailLeadInfoDealData>[];
      json['Data'].forEach((v) {
        data!.add(new DetailLeadInfoDealData.fromJson(v));
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

class DetailLeadInfoDealData {
  int? dealId;
  String? dealCode;
  String? customerCode;
  String? typeCustomer;
  int? customerLeadId;
  String? pipelineCode;
  String? journeyCode;
  String? dealName;
  int? probability;
  String? createdAt;
  int? saleId;
  String? staffName;
  int? amount;
  String? dateLastCare;
  int? diffDay;
  String? journeyName;
  int? relatedWork;
  int? appointment;

  DetailLeadInfoDealData(
      {this.dealId,
      this.dealCode,
      this.customerCode,
      this.typeCustomer,
      this.customerLeadId,
      this.pipelineCode,
      this.journeyCode,
      this.dealName,
      this.probability,
      this.createdAt,
      this.saleId,
      this.staffName,
      this.amount,
      this.dateLastCare,
      this.diffDay,
      this.journeyName,
      this.relatedWork,
      this.appointment});

  DetailLeadInfoDealData.fromJson(Map<String, dynamic> json) {
    dealId = json['deal_id'];
    dealCode = json['deal_code'];
    customerCode = json['customer_code'];
    typeCustomer = json['type_customer'];
    customerLeadId = json['customer_lead_id'];
    pipelineCode = json['pipeline_code'];
    journeyCode = json['journey_code'];
    dealName = json['deal_name'];
    probability = json['probability'];
    createdAt = json['created_at'];
    saleId = json['sale_id'];
    staffName = json['staff_name'];
    amount = json['amount'];
    dateLastCare = json['date_last_care'];
    diffDay = json['diff_day'];
    journeyName = json['journey_name'];
    relatedWork = json['related_work'];
    appointment = json['appointment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deal_id'] = this.dealCode;
    data['deal_code'] = this.dealId;
    data['customer_code'] = this.customerCode;
    data['type_customer'] = this.typeCustomer;
    data['customer_lead_id'] = this.customerLeadId;
    data['pipeline_code'] = this.pipelineCode;
    data['journey_code'] = this.journeyCode;
    data['deal_name'] = this.dealName;
    data['probability'] = this.probability;
    data['created_at'] = this.createdAt;
    data['sale_id'] = this.saleId;
    data['staff_name'] = this.staffName;
    data['amount'] = this.amount;
    data['date_last_care'] = this.dateLastCare;
    data['diff_day'] = this.diffDay;
    data['journey_name'] = this.journeyName;
    data['related_work'] = this.relatedWork;
    data['appointment'] = this.appointment;
    return data;
  }
}
