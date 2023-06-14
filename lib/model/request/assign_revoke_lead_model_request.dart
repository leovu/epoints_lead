class AssignRevokeLeadRequestModel {
  String? type;
  String? customerLeadCode;
  int? saleId;
  int? timeRevokeLead;

  AssignRevokeLeadRequestModel(
      {this.type, this.customerLeadCode, this.saleId, this.timeRevokeLead});

  AssignRevokeLeadRequestModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    customerLeadCode = json['customer_lead_code'];
    saleId = json['sale_id'];
    timeRevokeLead = json['time_revoke_lead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['customer_lead_code'] = this.customerLeadCode;
    data['sale_id'] = this.saleId;
    data['time_revoke_lead'] = this.timeRevokeLead;
    return data;
  }
}