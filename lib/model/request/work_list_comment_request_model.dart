class WorkListCommentRequestModel {
  int? customerLeadID;

  WorkListCommentRequestModel({this.customerLeadID});

  WorkListCommentRequestModel.fromJson(Map<String, dynamic> json) {
    customerLeadID = json['customer_lead_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_id'] = this.customerLeadID;
    return data;
  }
}