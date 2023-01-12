class WorkListCommentResponseModel {
  List<WorkListCommentModel> data;
  int errorCode;
  String errorDescription;
  WorkListCommentResponseModel({this.data});

  WorkListCommentResponseModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <WorkListCommentModel>[];

      json['Data'].forEach((v) {
        data.add(new WorkListCommentModel.fromJson(v));
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

class WorkListCommentModel {
  int customerLeadCommentId;
  int customerLeadId;
  int customerLeadParentCommentId;
  int staffId;
  String staffName;
  String staffAvatar;
  String message;
  String timeText;
  String path;
  List<WorkListCommentModel> listObject;
  bool isSubComment;

  WorkListCommentModel(
      {this.customerLeadCommentId,
      this.customerLeadId,
      this.customerLeadParentCommentId,
      this.staffId,
      this.staffName,
      this.staffAvatar,
      this.message,
      this.timeText,
      this.path,
      this.listObject});

  WorkListCommentModel.fromJson(Map<String, dynamic> json) {
    customerLeadCommentId = json['customer_lead_comment_id'];
    customerLeadId = json['customer_lead_id'];
    customerLeadParentCommentId = json['customer_lead_parent_comment_id'];
    staffId = json['staff_id'];
    staffName = json['staff_name'];
    staffAvatar = json['staff_avatar'];
    message = json['message'];
    timeText = json['time_text'];
    path = json['path'];
    if (json['list_object'] != null) {
      listObject = <WorkListCommentModel>[];
      json['list_object'].forEach((v) {
        var model = new WorkListCommentModel.fromJson(v);
        model.isSubComment = true;
        listObject.add(model);
      });
    }
    isSubComment = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_comment_id'] = this.customerLeadCommentId;
    data['customer_lead_id'] = this.customerLeadId;
    data['customer_lead_parent_comment_id'] = this.customerLeadParentCommentId;
    data['staff_id'] = this.staffId;
    data['staff_name'] = this.staffName;
    data['staff_avatar'] = this.staffAvatar;
    data['message'] = this.message;
    data['time_text'] = this.timeText;
    data['path'] = this.path;
    if (this.listObject != null) {
      data['list_object'] = this.listObject.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
