class GetAllocatorModelReponse {
  int? errorCode;
  String? errorDescription;
  List<AllocatorData>? data;

  GetAllocatorModelReponse({this.errorCode, this.errorDescription, this.data});

  GetAllocatorModelReponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <AllocatorData>[];
      json['Data'].forEach((v) {
        data!.add(new AllocatorData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDescription'] = this.errorDescription;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllocatorData {
  int? staffId;
  String? fullName;
  bool? selected;

  AllocatorData({this.staffId, this.fullName, this.selected});

  AllocatorData.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
    fullName = json['full_name'];
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    data['full_name'] = this.fullName;
    data['selected'] = this.selected;
    return data;
  }
}
