class WorkListStaffRequestModel {
  int manageProjectId;

  WorkListStaffRequestModel({this.manageProjectId});

  WorkListStaffRequestModel.fromJson(Map<String, dynamic> json) {
    manageProjectId = json['manage_project_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manage_project_id'] = this.manageProjectId;
    return data;
  }
}
