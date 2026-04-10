class WorkListStaffRequestModel {
  int? manageProjectId;
  String? staffName;
  String? branchId;

  WorkListStaffRequestModel({this.manageProjectId, this.staffName, this.branchId});

  WorkListStaffRequestModel.fromJson(Map<String, dynamic> json) {
    manageProjectId = json['manage_project_id'];
    staffName = json['staff_name'];
    branchId = json['branch_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manage_project_id'] = this.manageProjectId;
    data['staff_name'] = this.staffName;
    data['branch_id'] = this.branchId;
    return data;
  }
}
