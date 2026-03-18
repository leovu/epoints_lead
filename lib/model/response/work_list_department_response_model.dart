class WorkListDepartmentResponseModel {
  List<WorkListDepartmentModel>? data;

  WorkListDepartmentResponseModel({this.data});

  WorkListDepartmentResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = <WorkListDepartmentModel>[];
      json['Data'].forEach((v) {
        data!.add(new WorkListDepartmentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkListDepartmentModel {
  int? departmentId;
  String? departmentName;

  WorkListDepartmentModel({this.departmentId, this.departmentName});

  WorkListDepartmentModel.fromJson(Map<String, dynamic> json) {
    departmentId = json['department_id'];
    departmentName = json['department_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['department_id'] = this.departmentId;
    data['department_name'] = this.departmentName;
    return data;
  }
}