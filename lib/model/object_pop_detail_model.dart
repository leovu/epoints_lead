class ObjectPopDetailModel {
  int customer_lead_id;
  String customer_lead_code;
  bool status;

  ObjectPopDetailModel({this.customer_lead_id, this.customer_lead_code, this.status});

  factory ObjectPopDetailModel.fromJson(Map<String, dynamic> parsedJson) {
    return ObjectPopDetailModel(
        customer_lead_id: parsedJson['customer_lead_id'],
        customer_lead_code: parsedJson['customer_lead_code'],
        status: parsedJson['status']);
  }
Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_id'] = this.customer_lead_id;
    data['customer_lead_code'] = this.customer_lead_code;
     data['status'] = this.status;

    return data;
  }

}