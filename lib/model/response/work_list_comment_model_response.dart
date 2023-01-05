class WorkListCommentResponseModel {
  List<WorkListCommentModel> data;

  WorkListCommentResponseModel({this.data});

  WorkListCommentResponseModel.fromJson(Map<String, dynamic> json) {
    // if (json != null) {
    //   data = <WorkListCommentModel>[];
    //   json.forEach((v) {
    //     data.add(new WorkListCommentModel.fromJson(v));
    //   });
    // }

    if (json['Data'] != null) {
      data = <WorkListCommentModel>[];
      json['Data'].forEach((v) {
        data.add(new WorkListCommentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkListCommentModel {
  int manageCommentId;
  int manageWorkId;
  int manageParentCommentId;
  int staffId;
  String staffName;
  String staffAvatar;
  String message;
  String timeText;
  String path;
  List<WorkListCommentModel> listObject;
  bool isSubComment;

  WorkListCommentModel(
      {this.manageCommentId,
        this.manageWorkId,
        this.manageParentCommentId,
        this.staffId,
        this.staffName,
        this.staffAvatar,
        this.message,
        this.timeText,
        this.path,
        this.listObject});

  WorkListCommentModel.fromJson(Map<String, dynamic> json) {
    manageCommentId = json['manage_comment_id'];
    manageWorkId = json['manage_work_id'];
    manageParentCommentId = json['manage_parent_comment_id'];
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
    data['manage_comment_id'] = this.manageCommentId;
    data['manage_work_id'] = this.manageWorkId;
    data['manage_parent_comment_id'] = this.manageParentCommentId;
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