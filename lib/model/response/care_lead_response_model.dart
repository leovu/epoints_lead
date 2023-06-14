class CareLeadResponseModel {
  int? errorCode;
  String? errorDescription;
  List<CareLeadData>? data;

  CareLeadResponseModel({this.errorCode, this.errorDescription, this.data});

  CareLeadResponseModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <CareLeadData>[];
      json['Data'].forEach((v) {
        data!.add(new CareLeadData.fromJson(v));
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

class CareLeadData {
  int? manageWorkId;
  String? manageWorkCode;
  String? manageWorkCustomerType;
  int? manageProjectId;
  String? manageProjectName;
  int? manageTypeWorkId;
  String? manageTypeWorkKey;
  String? manageTypeWorkName;
  String? manageTypeWorkIcon;
  String? createdAt;
  String? manageWorkTitle;
  String? dateStart;
  String? dateEnd;
  String? dateFinish;
  int? processorId;
  String? staffFullName;
  String? staffAvatar;
  int? manageStatusId;
  String? manageStatusName;
  String? manageStatusColor;
  List<ListTagCareLead>? listTag;
  int? countFile;
  int? countComment;
  int? daysLate;

  CareLeadData(
      {this.manageWorkId,
      this.manageWorkCode,
      this.manageWorkCustomerType,
      this.manageProjectId,
      this.manageProjectName,
      this.manageTypeWorkId,
      this.manageTypeWorkKey,
      this.manageTypeWorkName,
      this.manageTypeWorkIcon,
      this.createdAt,
      this.manageWorkTitle,
      this.dateStart,
      this.dateEnd,
      this.dateFinish,
      this.processorId,
      this.staffFullName,
      this.staffAvatar,
      this.manageStatusId,
      this.manageStatusName,
      this.manageStatusColor,
      this.listTag,
      this.countFile,
      this.countComment,
      this.daysLate});

  CareLeadData.fromJson(Map<String, dynamic> json) {
    manageWorkId = json['manage_work_id'];
    manageWorkCode = json['manage_work_code'];
    manageWorkCustomerType = json['manage_work_customer_type'];
    manageProjectId = json['manage_project_id'];
    manageProjectName = json['manage_project_name'];
    manageTypeWorkId = json['manage_type_work_id'];
    manageTypeWorkKey = json['manage_type_work_key'];
    manageTypeWorkName = json['manage_type_work_name'];
    manageTypeWorkIcon = json['manage_type_work_icon'];
    createdAt = json['created_at'];
    manageWorkTitle = json['manage_work_title'];
    dateStart = json['date_start'];
    dateEnd = json['date_end'];
    dateFinish = json['date_finish'];
    processorId = json['processor_id'];
    staffFullName = json['staff_full_name'];
    staffAvatar = json['staff_avatar'];
    manageStatusId = json['manage_status_id'];
    manageStatusName = json['manage_status_name'];
    manageStatusColor = json['manage_status_color'];
    if (json['list_tag'] != null) {
      listTag = <ListTagCareLead>[];
      json['list_tag'].forEach((v) {
        listTag!.add(new ListTagCareLead.fromJson(v));
      });
    }
    countFile = json['count_file'];
    countComment = json['count_comment'];
    daysLate = json['days_late'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manage_work_id'] = this.manageWorkId;
    data['manage_work_code'] = this.manageWorkCode;
    data['manage_work_customer_type'] = this.manageWorkCustomerType;
    data['manage_project_id'] = this.manageProjectId;
    data['manage_project_name'] = this.manageProjectName;
    data['manage_type_work_id'] = this.manageTypeWorkId;
    data['manage_type_work_key'] = this.manageTypeWorkKey;
    data['manage_type_work_name'] = this.manageTypeWorkName;
    data['manage_type_work_icon'] = this.manageTypeWorkIcon;
    data['created_at'] = this.createdAt;
    data['manage_work_title'] = this.manageWorkTitle;
    data['date_start'] = this.dateStart;
    data['date_end'] = this.dateEnd;
    data['date_finish'] = this.dateFinish;
    data['processor_id'] = this.processorId;
    data['staff_full_name'] = this.staffFullName;
    data['staff_avatar'] = this.staffAvatar;
    data['manage_status_id'] = this.manageStatusId;
    data['manage_status_name'] = this.manageStatusName;
    data['manage_status_color'] = this.manageStatusColor;
    if (this.listTag != null) {
      data['list_tag'] = this.listTag!.map((v) => v.toJson()).toList();
    }
    data['count_file'] = this.countFile;
    data['count_comment'] = this.countComment;
    data['days_late'] = this.daysLate;
    return data;
  }
}

class ListTagCareLead {
  int? manageWorkTagId;
  int? manageWorkId;
  int? manageTagId;
  String? tagName;

  ListTagCareLead(
      {this.manageWorkTagId,
      this.manageWorkId,
      this.manageTagId,
      this.tagName});

  ListTagCareLead.fromJson(Map<String, dynamic> json) {
    manageWorkTagId = json['manage_work_tag_id'];
    manageWorkId = json['manage_work_id'];
    manageTagId = json['manage_tag_id'];
    tagName = json['tag_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manage_work_tag_id'] = this.manageWorkTagId;
    data['manage_work_id'] = this.manageWorkId;
    data['manage_tag_id'] = this.manageTagId;
    data['tag_name'] = this.tagName;
    return data;
  }
}
