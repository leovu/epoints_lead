class MessageLeadResponseModel {
  int errorCode;
  String errorDescription;
  List<MessageLeadData> data;

  MessageLeadResponseModel({this.errorCode, this.errorDescription, this.data});

  MessageLeadResponseModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <MessageLeadData>[];
      json['Data'].forEach((v) {
        data.add(new MessageLeadData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDescription'] = this.errorDescription;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageLeadData {
  int customerLeadCommentId;
  int customerLeadId;
  int parentCustomerLeadCommentId;
  String message;
  int staffId;
  String createdByName;
  String createdAt;
  int createdById;
  String path;

  MessageLeadData(
      {this.customerLeadCommentId,
      this.customerLeadId,
      this.parentCustomerLeadCommentId,
      this.message,
      this.staffId,
      this.createdByName,
      this.createdAt,
      this.createdById,
      this.path});

  MessageLeadData.fromJson(Map<String, dynamic> json) {
    customerLeadCommentId = json['customer_lead_comment_id'];
    customerLeadId = json['customer_lead_id'];
    parentCustomerLeadCommentId = json['parent_customer_lead_comment_id'];
    message = json['message'];
    staffId = json['staff_id'];
    createdByName = json['created_by_name'];
    createdAt = json['created_at'];
    createdById = json['created_by_id'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_comment_id'] = this.customerLeadCommentId;
    data['customer_lead_id'] = this.customerLeadId;
    data['parent_customer_lead_comment_id'] = this.parentCustomerLeadCommentId;
    data['message'] = this.message;
    data['staff_id'] = this.staffId;
    data['created_by_name'] = this.createdByName;
    data['created_at'] = this.createdAt;
    data['created_by_id'] = this.createdById;
    data['path'] = this.path;
    return data;
  }
}
