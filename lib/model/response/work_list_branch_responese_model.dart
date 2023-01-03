class WorkListBranchResponseModel {
  List<WorkListBranchModel> data;

  WorkListBranchResponseModel({this.data});

  WorkListBranchResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = <WorkListBranchModel>[];
      json['Data'] .forEach((v) {
        data.add(new WorkListBranchModel.fromJson(v));
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

class WorkListBranchModel {
  int branchId;
  String branchName;

  WorkListBranchModel({this.branchId, this.branchName});

  WorkListBranchModel.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    branchName = json['branch_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch_id'] = this.branchId;
    data['branch_name'] = this.branchName;
    return data;
  }
}