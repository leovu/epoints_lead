class DescriptionModelResponse {
  int errorCode;
  String errorDescription;
  

  DescriptionModelResponse({this.errorCode, this.errorDescription});

  DescriptionModelResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'] ?? 0;
    errorDescription = json['ErrorDescription'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDescription'] = this.errorDescription;
    return data;
  }
}