class WorkUploadFileResponseModel {
  int? errorCode;
  String? errorDescription;
  WorkUploadFileResponse? data;

  WorkUploadFileResponseModel({this.errorCode, this.errorDescription, this.data});

  WorkUploadFileResponseModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    data = json['Data'] != null ? new WorkUploadFileResponse.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDescription'] = this.errorDescription;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}




class WorkUploadFileResponse {
  String? path;

  WorkUploadFileResponse({this.path});

  WorkUploadFileResponse.fromJson(Map<String, dynamic> json) {
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    return data;
  }
}