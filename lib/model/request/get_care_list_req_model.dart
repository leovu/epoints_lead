
class GetCareListReqModel {
  int? customer_lead_id;

  GetCareListReqModel({this.customer_lead_id});

  GetCareListReqModel.fromJson(Map<String, dynamic> json) {
    customer_lead_id = json['customer_lead_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_id'] = this.customer_lead_id;
    return data;
  }
}