class AddWorkRequestModel {
  String manageWorkTitle;
  String manageWorkCustomerType;
  int manageTypeWorkId;
  // String date_start;
  String date_finish;
  String from_date;
  String to_date;

  int time;
  String timeType;
  int processorId;
  int approveId;
  RemindWork remindWork;
  int progress;
  List<StaffSupport> staffSupport;
  int parentId;
  String description;
  int manageProjectId;
  int customerId;
  List<ListTag> listTag;
  String typeCardWork;
  int priority;
  int manageStatusId;
  int isApproveId;
  RepeatWork repeatWork;
  String createObjectType;
  int createObjectId;

  AddWorkRequestModel(
      {this.manageWorkTitle,
      this.manageWorkCustomerType,
      this.manageTypeWorkId,
      // this.date_start,
      this.date_finish,
      this.from_date,
      this.to_date,
      this.time,
      this.timeType,
      this.processorId,
      this.approveId,
      this.remindWork,
      this.progress,
      this.staffSupport,
      this.parentId,
      this.description,
      this.manageProjectId,
      this.customerId,
      this.listTag,
      this.typeCardWork,
      this.priority,
      this.manageStatusId,
      this.isApproveId,
      this.repeatWork,
      this.createObjectType,
      this.createObjectId});

  AddWorkRequestModel.fromJson(Map<String, dynamic> json) {
    manageWorkTitle = json['manage_work_title'];
    manageWorkCustomerType = json['manage_work_customer_type'];
    manageTypeWorkId = json['manage_type_work_id'];
    // date_start = json['date_start'];

    date_finish = json['date_finish'];
    from_date = json['from_date'];
    to_date = json['to_date'];

    time = json['time'];
    timeType = json['time_type'];
    processorId = json['processor_id'];
    approveId = json['approve_id'];
    remindWork = json['remind_work'] != null ?
         new RemindWork.fromJson(json['remind_work'])
        : null;
    progress = json['progress'];
    if (json['staff_support'] != null) {
      staffSupport = <StaffSupport>[];
      json['staff_support'].forEach((v) {
        staffSupport.add(new StaffSupport.fromJson(v));
      });
    }
    parentId = json['parent_id'];
    description = json['description'];
    manageProjectId = json['manage_project_id'];
    customerId = json['customer_id'];
    if (json['list_tag'] != null) {
      listTag = <ListTag>[];
      json['list_tag'].forEach((v) {
        listTag.add(new ListTag.fromJson(v));
      });
    }
    typeCardWork = json['type_card_work'];
    priority = json['priority'];
    manageStatusId = json['manage_status_id'];
    isApproveId = json['is_approve_id'];
    repeatWork = json['repeat_work'] != null ?
         new RepeatWork.fromJson(json['repeat_work'])
        : null;
    createObjectType = json['create_object_type'];
    createObjectId = json['create_object_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manage_work_title'] = this.manageWorkTitle;
    data['manage_work_customer_type'] = this.manageWorkCustomerType;
    data['manage_type_work_id'] = this.manageTypeWorkId;
    // data['date_start'] = this.date_start;

    data['date_finish'] = this.date_finish;
    data['from_date'] = this.from_date;
    data['to_date'] = this.to_date;

    data['time'] = this.time;
    data['time_type'] = this.timeType;
    data['processor_id'] = this.processorId;
    data['approve_id'] = this.approveId;
    if (this.remindWork != null) {
      data['remind_work'] = this.remindWork.toJson();
    }
    data['progress'] = this.progress;
    if (this.staffSupport != null) {
      data['staff_support'] =
          this.staffSupport.map((v) => v.toJson()).toList();
    }
    data['parent_id'] = this.parentId;
    data['description'] = this.description;
    data['manage_project_id'] = this.manageProjectId;
    data['customer_id'] = this.customerId;
    if (this.listTag != null) {
      data['list_tag'] = this.listTag.map((v) => v.toJson()).toList();
    }
    data['type_card_work'] = this.typeCardWork;
    data['priority'] = this.priority;
    data['manage_status_id'] = this.manageStatusId;
    data['is_approve_id'] = this.isApproveId;
    if (this.repeatWork != null) {
      data['repeat_work'] = this.repeatWork.toJson();
    }
    data['create_object_type'] = this.createObjectType;
    data['create_object_id'] = this.createObjectId;
    return data;
  }
}

class RemindWork {
  String dateRemind;
  int time;
  String timeType;
  String description;

  RemindWork({this.dateRemind, this.time, this.timeType, this.description});

  RemindWork.fromJson(Map<String, dynamic> json) {
    dateRemind = json['date_remind'];
    time = json['time'];
    timeType = json['time_type'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_remind'] = this.dateRemind;
    data['time'] = this.time;
    data['time_type'] = this.timeType;
    data['description'] = this.description;
    return data;
  }
}

class StaffSupport {
  int staffId;

  StaffSupport({this.staffId});

  StaffSupport.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    return data;
  }
}

class ListTag {
  int manageTagId;

  ListTag({this.manageTagId});

  ListTag.fromJson(Map<String, dynamic> json) {
    manageTagId = json['manage_tag_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manage_tag_id'] = this.manageTagId;
    return data;
  }
}

class RepeatWork {
  String repeatType;
  String repeatEnd;
  String repeatEndFullTime;
  String repeatTime;
  List<ListDate> listDate;

  RepeatWork(
      {this.repeatType,
      this.repeatEnd,
      this.repeatEndFullTime,
      this.repeatTime,
      this.listDate});

  RepeatWork.fromJson(Map<String, dynamic> json) {
    repeatType = json['repeat_type'];
    repeatEnd = json['repeat_end'];
    repeatEndFullTime = json['repeat_end_full_time'];
    repeatTime = json['repeat_time'];
    if (json['list_date'] != null) {
      listDate = <ListDate>[];
      json['list_date'].forEach((v) {
        listDate.add(new ListDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['repeat_type'] = this.repeatType;
    data['repeat_end'] = this.repeatEnd;
    data['repeat_end_full_time'] = this.repeatEndFullTime;
    data['repeat_time'] = this.repeatTime;
    if (this.listDate != null) {
      data['list_date'] = this.listDate.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListDate {
  int date;

  ListDate({this.date});

  ListDate.fromJson(Map<String, dynamic> json) {
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    return data;
  }
}
