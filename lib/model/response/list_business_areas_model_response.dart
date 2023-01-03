class ListBusinessAreasModelResponse {
  int errorCode;
  String errorDescription;
  List<ListBusinessAreasItem> data;

  ListBusinessAreasModelResponse(
      {this.errorCode, this.errorDescription, this.data});

  ListBusinessAreasModelResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <ListBusinessAreasItem>[];
      json['Data'].forEach((v) {
        data.add(ListBusinessAreasItem.fromJson(v));
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

class ListBusinessAreasItem {
  String businessName;
  String description;
  int createdBy;
  String createdAt;
  bool selected;

  ListBusinessAreasItem({this.businessName, this.description, this.createdBy, this.createdAt});

  ListBusinessAreasItem.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    description = json['description'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_name'] = this.businessName;
    data['description'] = this.description;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['selected'] = this.selected;
    return data;
  }
}
