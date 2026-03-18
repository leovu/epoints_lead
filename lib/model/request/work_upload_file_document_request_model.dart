class WorkUploadFileDocumentRequestModel {
  int? manageWorkId;
  String? path;

  WorkUploadFileDocumentRequestModel({this.manageWorkId, this.path});

  WorkUploadFileDocumentRequestModel.fromJson(Map<String, dynamic> json) {
    manageWorkId = json['manage_work_id'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manage_work_id'] = this.manageWorkId;
    data['path'] = this.path;
    return data;
  }
}