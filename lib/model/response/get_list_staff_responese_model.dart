class WorkListStaffResponseModel {
  List<WorkListStaffModel>? data;

  WorkListStaffResponseModel({this.data});

  WorkListStaffResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = <WorkListStaffModel>[];
      json['Data'].forEach((v) {
        data!.add(new WorkListStaffModel.fromJson(v));
      });
    }

  //   GetAllocatorModelReponse.fromJson(Map<String, dynamic> json) {
  //   errorCode = json['ErrorCode'];
  //   errorDescription = json['ErrorDescription'];
  //   if (json['Data'] != null) {
  //     data = <AllocatorData>[];
  //     json['Data'].forEach((v) {
  //       data.add(new AllocatorData.fromJson(v));
  //     });
  //   }
  // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkListStaffModel {
  int? staffId;
  String? staffName;
  String? staffAvatar;
  int? branchId;
  int? departmentId;
  String? branchName;
  String? departmentName;
  bool? isSelected;

  WorkListStaffModel({
    this.staffId,
    this.staffName,
    this.staffAvatar,
    this.branchId,
    this.departmentId,
    this.branchName,
    this.departmentName,
    this.isSelected = false
  });

  WorkListStaffModel.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
    staffName = json['staff_name'];
    staffAvatar = json['staff_avatar'];
    branchId = json['branch_id'];
    departmentId = json['department_id'];
    branchName = json['branch_name'];
    departmentName = json['department_name'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    data['staff_name'] = this.staffName;
    data['staff_avatar'] = this.staffAvatar;
    data['branch_id'] = this.branchId;
    data['department_id'] = this.departmentId;
    data['branch_name'] = this.branchName;
    data['department_name'] = this.departmentName;
    return data;
  }
}