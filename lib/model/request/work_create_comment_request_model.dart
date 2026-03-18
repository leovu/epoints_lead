class WorkCreateCommentRequestModel {
  int? customerLeadId;
  int? customerLeadParentCommentId;
  String? message;
  String? path;

  WorkCreateCommentRequestModel(
      {this.customerLeadId, this.customerLeadParentCommentId, this.message, this.path});

  WorkCreateCommentRequestModel.fromJson(Map<String, dynamic> json) {
    customerLeadId = json['customer_lead_id'];
    customerLeadParentCommentId = json['customer_lead_parent_comment_id'];
    message = json['message'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_id'] = this.customerLeadId;
    data['customer_lead_parent_comment_id'] = this.customerLeadParentCommentId;
    data['message'] = this.message;
    data['path'] = this.path;
    return data;
  }
}