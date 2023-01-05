class WorkCreateCommentRequestModel {
  int manageWorkId;
  int manageParentCommentId;
  String message;
  String path;

  WorkCreateCommentRequestModel(
      {this.manageWorkId, this.manageParentCommentId, this.message, this.path});

  WorkCreateCommentRequestModel.fromJson(Map<String, dynamic> json) {
    manageWorkId = json['manage_work_id'];
    manageParentCommentId = json['manage_parent_comment_id'];
    message = json['message'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manage_work_id'] = this.manageWorkId;
    data['manage_parent_comment_id'] = this.manageParentCommentId;
    data['message'] = this.message;
    data['path'] = this.path;
    return data;
  }
}