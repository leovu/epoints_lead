class GetContactLeadReqModel {
  String? customer_lead_code;

  GetContactLeadReqModel({this.customer_lead_code});

  GetContactLeadReqModel.fromJson(Map<String, dynamic> json) {
    customer_lead_code = json['customer_lead_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_code'] = this.customer_lead_code;
    return data;
  }
}