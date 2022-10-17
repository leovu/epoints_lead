class AddLeadModelResponse {
  int errorCode;
  String errorDescription;
  AddLeadData data;

  AddLeadModelResponse({this.errorCode, this.errorDescription, this.data});

  AddLeadModelResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    data = json['Data'] != null ? new AddLeadData.fromJson(json['Data']) : null;
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

class AddLeadData {
  int customerLeadId;

  AddLeadData({this.customerLeadId});

  AddLeadData.fromJson(Map<String, dynamic> json) {
    customerLeadId = json['customer_lead_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_id'] = this.customerLeadId;
    return data;
  }
}