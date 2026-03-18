class DetailPotentialModelResponse {
  int? errorCode;
  String? errorDescription;
  DetailPotentialData? data;

  DetailPotentialModelResponse(
      {this.errorCode, this.errorDescription, this.data});

  DetailPotentialModelResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    data = json['Data'] != null
        ? new DetailPotentialData.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDescription'] = this.errorDescription;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class DetailPotentialData {
  int? customerLeadId;
  String? customerLeadCode;
  String? fullName;
  String? phone;
  String? hotline;
  String? taxCode;
  int? customerSource;
  String? customerSourceName;
  String? customerType;
  String? pipelineCode;
  String? pipelineName;
  String? journeyCode;
  String? journeyName;
  String? email;
  String? gender;
  int? provinceId;
  String? provinceType;
  String? provinceName;
  int? districtId;
  String? districtType;
  String? districtName;
  int? wardId;
  String? wardType;
  String? wardName;
  String? address;
  String? zalo;
  String? fanpage;
  int? saleId;
  List<Tag>? tag;
  String? saleName;
  int? isConvert;
  String? representative;
  String? businessClue;
  String? businessClueName;
  int? bussinessId;
  String? businessName;
  int? employees;
  int? timeRevokeLead;
  String? dateRevoke;
  String? allocationDate;
  String? avatar;
  num? amount;
  String? dateLastCare;
  int? diffDay;
  int? relatedWork;
  int? appointment;
  String? birthday;
  String? position;
  String? customerTypeName;
  int? customerGroupId;
  String? customerGroupName;
  int? customerLeadReferId;
  String? customerLeadReferName;
  String? genderVi;
  String? branchCode;
  String? branchName;
  int? employQty;
  String? createdAt;
  String? createdByName;
  String? updatedAt;
  String? updatedByName;
  int? assignBy;
  String? assignByName;
  String? fullAddress;
  int? customerContactId;
  String? customerContactName;
  List<CustomerDetailConfigModel>? tabConfigs;
  List<JourneyTracking>? journeyTracking;
  List<InfoDeal>? infoDeal;
  List<CustomerCare>? customerCare;
  List<CareHistory>? careHistory;
  List<ContactList>? contactList;

  int? zaloId;
  int? facebookId;
  String? note;
  String? website;



  DetailPotentialData(
      {this.customerLeadId,
      this.customerLeadCode,
      this.fullName,
      this.phone,
      this.hotline,
      this.taxCode,
      this.customerSource,
      this.customerSourceName,
      this.customerType,
      this.pipelineCode,
      this.pipelineName,
      this.journeyCode,
      this.journeyName,
      this.email,
      this.gender,
      this.provinceId,
      this.provinceType,
      this.provinceName,
      this.districtId,
      this.districtType,
      this.districtName,
      this.wardId,
      this.wardType,
      this.wardName,
      this.address,
      this.zalo,
      this.fanpage,
      this.saleId,
      this.tag,
      this.saleName,
      this.isConvert,
      this.representative,
      this.businessClue,
      this.businessClueName,
      this.bussinessId,
      this.businessName,
      this.employees,
      this.timeRevokeLead,
      this.dateRevoke,
      this.allocationDate,
      this.avatar,
      this.amount,
      this.dateLastCare,
      this.diffDay,
      this.relatedWork,
      this.appointment,
      this.birthday,
      this.position,
      this.journeyTracking,
      this.infoDeal,
      this.customerCare,
      this.careHistory,
      this.contactList,
      this.customerTypeName,
      this.customerGroupId,
      this.customerGroupName,
      this.customerLeadReferId,
      this.customerLeadReferName,
      this.genderVi,
      this.branchCode,
      this.branchName,
      this.employQty,
      this.createdAt,
      this.createdByName,
      this.updatedAt,
      this.updatedByName,
      this.assignBy,
      this.assignByName,
      this.fullAddress,
      this.customerContactId,
      this.customerContactName,
      this.tabConfigs,
      this.zaloId,
      this.facebookId,
      this.note,
      this.website});

  DetailPotentialData.fromJson(Map<String, dynamic> json) {
    customerLeadId = json['customer_lead_id'];
    customerLeadCode = json['customer_lead_code'];
    fullName = json['full_name'];
    phone = json['phone'];
    hotline = json['hotline'];
    taxCode = json['tax_code'];
    customerSource = json['customer_source'];
    customerSourceName = json['customer_source_name'];
    customerType = json['customer_type'];
    pipelineCode = json['pipeline_code'];
    pipelineName = json['pipeline_name'];
    journeyCode = json['journey_code'];
    journeyName = json['journey_name'];
    email = json['email'];
    gender = json['gender'];
    provinceId = json['province_id'];
    provinceType = json['province_type'];
    provinceName = json['province_name'];
    districtId = json['district_id'];
    districtType = json['district_type'];
    districtName = json['district_name'];
    wardId = json['ward_id'];
    wardType = json['ward_type'];
    wardName = json['ward_name'];
    address = json['address'];
    zalo = json['zalo'];
    fanpage = json['fanpage'];
    saleId = json['sale_id'];
    if (json['tag'] != null) {
      tag = <Tag>[];
      json['tag'].forEach((v) {
        tag!.add(new Tag.fromJson(v));
      });
    }
    saleName = json['sale_name'];
    isConvert = json['is_convert'];
    representative = json['representative'];
    businessClue = json['business_clue'];
    businessClueName = json['business_clue_name'];
    bussinessId = json['bussiness_id'];
    businessName = json['business_name'];
    employees = json['employees'];
    timeRevokeLead = json['time_revoke_lead'];
    dateRevoke = json['date_revoke'];
    allocationDate = json['allocation_date'];
    avatar = json['avatar'];
    amount = json['amount'];
    dateLastCare = json['date_last_care'];
    diffDay = json['diff_day'];
    relatedWork = json['related_work'];
    appointment = json['appointment'];
    birthday = json['birthday'];
    position = json['position'];
    customerTypeName = json['customer_type_name'];
    customerGroupId = json['customer_group_id'];
    customerGroupName = json['customer_group_name'];
    customerLeadReferId = json['customer_lead_refer_id'];
    customerLeadReferName = json['customer_lead_refer_name'];
    genderVi = json['gender_vi'];
    branchCode = json['branch_code'];
    branchName = json['branch_name'];
    employQty = json['employ_qty'];
    createdAt = json['created_at'];
    createdByName = json['created_by_name'];
    updatedAt = json['updated_at'];
    updatedByName = json['updated_by_name'];
    assignBy = json['assign_by'];
    assignByName = json['assign_by_name'];
    fullAddress = json['full_address'];
    customerContactId = json['customer_contact_id'];
    customerContactName = json['customer_contact_name'];
    if (json['tab_configs'] != null) {
      tabConfigs = <CustomerDetailConfigModel>[];
      json['tab_configs'].forEach((v) {
        tabConfigs!.add(new CustomerDetailConfigModel.fromJson(v));
      });
    }

    if (json['journey_tracking'] != null) {
      journeyTracking = <JourneyTracking>[];
      json['journey_tracking'].forEach((v) {
        journeyTracking!.add(new JourneyTracking.fromJson(v));
      });
    }
    if (json['info_deal'] != null) {
      infoDeal = <InfoDeal>[];
      json['info_deal'].forEach((v) {
        infoDeal!.add(new InfoDeal.fromJson(v));
      });
    }
    if (json['customer_care'] != null) {
      customerCare = <CustomerCare>[];
      json['customer_care'].forEach((v) {
        customerCare!.add(new CustomerCare.fromJson(v));
      });
    }
    if (json['care_history'] != null) {
      careHistory = <CareHistory>[];
      json['care_history'].forEach((v) {
        careHistory!.add(new CareHistory.fromJson(v));
      });
    }
    if (json['contact_list'] != null) {
      contactList = <ContactList>[];
      json['contact_list'].forEach((v) {
        contactList!.add(new ContactList.fromJson(v));
      });
    }
    note = json['note'];
    zaloId = json['zalo_id'];
    facebookId = json['facebook_id'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_id'] = this.customerLeadId;
    data['customer_lead_code'] = this.customerLeadCode;
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['hotline'] = this.hotline;
    data['tax_code'] = this.taxCode;
    data['customer_source'] = this.customerSource;
    data['customer_source_name'] = this.customerSourceName;
    data['customer_type'] = this.customerType;
    data['pipeline_code'] = this.pipelineCode;
    data['pipeline_name'] = this.pipelineName;
    data['journey_code'] = this.journeyCode;
    data['journey_name'] = this.journeyName;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['province_id'] = this.provinceId;
    data['province_type'] = this.provinceType;
    data['province_name'] = this.provinceName;
    data['district_id'] = this.districtId;
    data['district_type'] = this.districtType;
    data['district_name'] = this.districtName;
    data['ward_id'] = this.wardId;
    data['ward_type'] = this.wardType;
    data['ward_name'] = this.wardName;
    data['address'] = this.address;
    data['zalo'] = this.zalo;
    data['fanpage'] = this.fanpage;
    data['sale_id'] = this.saleId;
    if (this.tag != null) {
      data['tag'] = this.tag!.map((v) => v.toJson()).toList();
    }
    data['sale_name'] = this.saleName;
    data['is_convert'] = this.isConvert;
    data['representative'] = this.representative;
    data['business_clue'] = this.businessClue;
    data['business_clue_name'] = this.businessClueName;
    data['bussiness_id'] = this.bussinessId;
    data['business_name'] = this.businessName;
    data['employees'] = this.employees;
    data['time_revoke_lead'] = this.timeRevokeLead;
    data['date_revoke'] = this.dateRevoke;
    data['allocation_date'] = this.allocationDate;
    data['avatar'] = this.avatar;
    data['amount'] = this.amount;
    data['date_last_care'] = this.dateLastCare;
    data['diff_day'] = this.diffDay;
    data['related_work'] = this.relatedWork;
    data['appointment '] = this.appointment;
    data['birthday'] = this.birthday;
    data['position'] = this.position;
    data['website'] = this.website;
    
    if (this.journeyTracking != null) {
      data['journey_tracking'] =
          this.journeyTracking!.map((v) => v.toJson()).toList();
    }
    if (this.infoDeal != null) {
      data['info_deal'] = this.infoDeal!.map((v) => v.toJson()).toList();
    }
    if (this.customerCare != null) {
      data['customer_care'] = this.customerCare!.map((v) => v.toJson()).toList();
    }
    if (this.careHistory != null) {
      data['care_history'] = this.careHistory!.map((v) => v.toJson()).toList();
    }
    if (this.contactList != null) {
      data['contact_list'] = this.contactList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerDetailConfigModel {
  int? customerConfigTabDetailId;
  String? code;
  String? tabNameVi;
  String? tabNameEn;
  int? sortOrder;
  int? total;

  CustomerDetailConfigModel(
      {this.customerConfigTabDetailId,
      this.code,
      this.tabNameVi,
      this.tabNameEn,
      this.sortOrder,
      this.total});

  CustomerDetailConfigModel.fromJson(Map<String, dynamic> json) {
    customerConfigTabDetailId = json['customer_config_tab_detail_id'];
    code = json['code'];
    tabNameVi = json['tab_name_vi'];
    tabNameEn = json['tab_name_en'];
    sortOrder = json['sort_order'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_config_tab_detail_id'] = this.customerConfigTabDetailId;
    data['code'] = this.code;
    data['tab_name_vi'] = this.tabNameVi;
    data['tab_name_en'] = this.tabNameEn;
    data['sort_order'] = this.sortOrder;
    data['total'] = this.total;
    return data;
  }
}

class Tag {
  int? tagId;
  String? keyword;
  String? tagName;

  Tag({this.tagId, this.keyword, this.tagName});

  Tag.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'];
    keyword = json['keyword'];
    tagName = json['tag_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag_id'] = this.tagId;
    data['keyword'] = this.keyword;
    data['tag_name'] = this.tagName;
    return data;
  }
}

class JourneyTracking {
  String? journeyCode;
  int? journeyId;
  String? journeyName;
  int? pipelineId;
  String? pipelineCode;
  String? backgroundColorJourney;
  bool? check;

  JourneyTracking(
      {this.journeyCode,
      this.journeyId,
      this.journeyName,
      this.pipelineId,
      this.pipelineCode,
      this.backgroundColorJourney,
      this.check});

  JourneyTracking.fromJson(Map<String, dynamic> json) {
    journeyCode = json['journey_code'];
    journeyId = json['journey_id'];
    journeyName = json['journey_name'];
    pipelineId = json['pipeline_id'];
    pipelineCode = json['pipeline_code'];
    backgroundColorJourney = json['background_color_journey'];
    check = json['check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['journey_code'] = this.journeyCode;
    data['journey_id'] = this.journeyId;
    data['journey_name'] = this.journeyName;
    data['pipeline_id'] = this.pipelineId;
    data['pipeline_code'] = this.pipelineCode;
    data['background_color_journey'] = this.backgroundColorJourney;
    data['check'] = this.check;
    return data;
  }
}

class InfoDeal {
  int? dealId;
  String? customerCode;
  int? customerLeadId;
  String? pipelineCode;
  String? journeyCode;
  String? dealName;
  int? probability;
  String? createdAt;
  int? saleId;
  String? staffName;
  int? amount;
  String? dateLastCare;
  int? diffDay;
  String? journeyName;
  int? relatedWork;
  int? appointment;

  InfoDeal(
      {this.dealId,
      this.customerCode,
      this.customerLeadId,
      this.pipelineCode,
      this.journeyCode,
      this.dealName,
      this.probability,
      this.createdAt,
      this.saleId,
      this.staffName,
      this.amount,
      this.dateLastCare,
      this.diffDay,
      this.journeyName,
      this.relatedWork,
      this.appointment});

  InfoDeal.fromJson(Map<String, dynamic> json) {
    dealId = json['deal_id'];
    customerCode = json['customer_code'];
    customerLeadId = json['customer_lead_id'];
    pipelineCode = json['pipeline_code'];
    journeyCode = json['journey_code'];
    dealName = json['deal_name'];
    probability = json['probability'];
    createdAt = json['created_at'];
    saleId = json['sale_id'];
    staffName = json['staff_name'];
    amount = json['amount'];
    dateLastCare = json['date_last_care'];
    diffDay = json['diff_day'];
    journeyName = json['journey_name'];
    relatedWork = json['related_work'];
    appointment = json['appointment '];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deal_id'] = this.dealId;
    data['customer_code'] = this.customerCode;
    data['customer_lead_id'] = this.customerLeadId;
    data['pipeline_code'] = this.pipelineCode;
    data['journey_code'] = this.journeyCode;
    data['deal_name'] = this.dealName;
    data['probability'] = this.probability;
    data['created_at'] = this.createdAt;
    data['sale_id'] = this.saleId;
    data['staff_name'] = this.staffName;
    data['amount'] = this.amount;
    data['date_last_care'] = this.dateLastCare;
    data['diff_day'] = this.diffDay;
    data['journey_name'] = this.journeyName;
    data['related_work'] = this.relatedWork;
    data['appointment '] = this.appointment;
    return data;
  }
}

class CustomerCare {
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
  int? countFile;
  int? countComment;
  int? daysLate;
  List<ListTagDetail>? listTag;

  CustomerCare(
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

  CustomerCare.fromJson(Map<String, dynamic> json) {
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
    countFile = json['count_file'];
    countComment = json['count_comment'];
    daysLate = json['days_late'];
    if (json['list_tag'] != null) {
      listTag = <ListTagDetail>[];
      json['list_tag'].forEach((v) {
        listTag!.add(new ListTagDetail.fromJson(v));
      });
    }
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
    data['count_file'] = this.countFile;
    data['count_comment'] = this.countComment;
    data['days_late'] = this.daysLate;
    if (this.listTag != null) {
      data['list_tag'] = this.listTag!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListTagDetail {
  int? manageWorkTagId;
  int? manageWorkId;
  int? manageTagId;
  String? tagName;

  ListTagDetail(
      {this.manageWorkTagId,
      this.manageWorkId,
      this.manageTagId,
      this.tagName});

  ListTagDetail.fromJson(Map<String, dynamic> json) {
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

class CareHistory {
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
  int? countFile;
  int? countComment;
  int? daysLate;

  CareHistory(
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
      this.countFile,
      this.countComment,
      this.daysLate});

  CareHistory.fromJson(Map<String, dynamic> json) {
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
    data['count_file'] = this.countFile;
    data['count_comment'] = this.countComment;
    data['days_late'] = this.daysLate;
    return data;
  }
}

class ContactList {
  int? customerContactId;
  String? customerLeadCode;
  String? fullName;
  String? address;
  String? phone;
  String? email;
  int? customerContactTilteId;
  String? customerContactType;
  String? customerContactTilteNameVi;
  String? customerContactTilteNameEn;
  String? customerContactTypeName;

  ContactList(
      {this.customerContactId,
      this.customerLeadCode,
      this.fullName,
      this.address,
      this.phone,
      this.email,
      this.customerContactTilteId,
      this.customerContactType,
      this.customerContactTilteNameVi,
      this.customerContactTilteNameEn,
      this.customerContactTypeName});

  ContactList.fromJson(Map<String, dynamic> json) {
    customerContactId = json['customer_contact_id'];
    customerLeadCode = json['customer_lead_code'];
    fullName = json['full_name'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    customerContactTilteId = json['customer_contact_tilte_id'];
    customerContactType = json['customer_contact_type'];
    customerContactTilteNameVi = json['customer_contact_tilte_name_vi'];
    customerContactTilteNameEn = json['customer_contact_tilte_name_en'];
    customerContactTypeName = json['customer_contact_type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_contact_id'] = this.customerContactId;
    data['customer_lead_code'] = this.customerLeadCode;
    data['full_name'] = this.fullName;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['customer_contact_tilte_id'] = this.customerContactTilteId;
    data['customer_contact_type'] = this.customerContactType;
    data['customer_contact_tilte_name_vi'] = this.customerContactTilteNameVi;
    data['customer_contact_tilte_name_en'] = this.customerContactTilteNameEn;
    data['customer_contact_type_name'] = this.customerContactTypeName;
    return data;
  }
}
