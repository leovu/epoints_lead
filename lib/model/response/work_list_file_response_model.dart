class WorkListFileResponseModel {
  List<WorkListFileModel> data;

  WorkListFileResponseModel({this.data});

  WorkListFileResponseModel.fromJson(List<dynamic> json) {
    if (json != null) {
      data = <WorkListFileModel>[];
      json.forEach((v) {
        data.add(new WorkListFileModel.fromJson(v));
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

class WorkListFileModel {
  int manageDocumentFileId;
  String fileName;
  String path;

  WorkListFileModel({this.manageDocumentFileId, this.fileName, this.path});

  WorkListFileModel.fromJson(Map<String, dynamic> json) {
    manageDocumentFileId = json['manage_document_file_id'];
    fileName = json['file_name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manage_document_file_id'] = this.manageDocumentFileId;
    data['file_name'] = this.fileName;
    data['path'] = this.path;
    return data;
  }
}