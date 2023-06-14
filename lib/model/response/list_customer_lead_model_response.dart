class ListCustomLeadModelReponse {
  int? errorCode;
  String? errorDescription;
  ListCustomLeadData? data;

  ListCustomLeadModelReponse(
      {this.errorCode, this.errorDescription, this.data});

  ListCustomLeadModelReponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'] ?? null;
    errorDescription = json['ErrorDescription'] ?? null;
    data = json['Data'] != null ? new ListCustomLeadData.fromJson(json['Data']) : null;
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

class ListCustomLeadData {
  ListCustomLeadPageInfo? pageInfo;
  List<ListCustomLeadItems>? items;

  ListCustomLeadData({this.pageInfo, this.items});

  ListCustomLeadData.fromJson(Map<String, dynamic> json) {
    pageInfo = (json['PageInfo'] != null) ?
         new ListCustomLeadPageInfo.fromJson(json['PageInfo'])
        : null ;
    if (json['Items'] != null) {
      items = <ListCustomLeadItems>[];
      json['Items'].forEach((v) {
        items!.add(new ListCustomLeadItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pageInfo != null) {
      data['PageInfo'] = this.pageInfo!.toJson();
    }
    if (this.items != null) {
      data['Items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListCustomLeadPageInfo {
  int? total;
  int? itemPerPage;
  int? from;
  int? to;
  int? currentPage;
  int? firstPage;
  int? lastPage;
  int? previousPage;
  int? nextPage;
  List<int>? pageRange;

  ListCustomLeadPageInfo(
      {this.total,
      this.itemPerPage,
      this.from,
      this.to,
      this.currentPage,
      this.firstPage,
      this.lastPage,
      this.previousPage,
      this.nextPage,
      this.pageRange});

  ListCustomLeadPageInfo.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0 ;
    itemPerPage = json['itemPerPage'] ??  10;
    from = json['from'] ?? 0;
    to = json['to'] ?? 0;
    currentPage = json['currentPage'] ?? 1;
    firstPage = json['firstPage'] ?? 1;
    lastPage = json['lastPage']??  0;
    previousPage = json['previousPage'] ?? 0;
    nextPage = json['nextPage'] ?? 1;
    (json['pageRange'] != null) ? pageRange = json['pageRange'].cast<int>() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['itemPerPage'] = this.itemPerPage;
    data['from'] = this.from;
    data['to'] = this.to;
    data['currentPage'] = this.currentPage;
    data['firstPage'] = this.firstPage;
    data['lastPage'] = this.lastPage;
    data['previousPage'] = this.previousPage;
    data['nextPage'] = this.nextPage;
    data['pageRange'] = this.pageRange;
    return data;
  }
}

class ListCustomLeadItems {
  String? avatar;
  int? customerSource;
  String? customerSourceName;
  int? customerLeadId;
  String? customerLeadCode;
  String? leadFullName;
  String? birthday;
  String? phone;
  String? customerType;
  int? saleId;
  String? staffFullName;
  String? zalo;
  int? isConvert;
  String? pipelineCode;
  String? pipelineName;
  String? journeyCode;
  String? journeyName;
  String? dateLastCare;
  List<Tag>? tag;
  int? diffDay;
  int? relatedWork;
  int? appointment;
  bool? selected;

  ListCustomLeadItems(
      {this.avatar,
      this.customerSource,
      this.customerSourceName,
      this.customerLeadId,
      this.customerLeadCode,
      this.leadFullName,
      this.birthday,
      this.phone,
      this.customerType,
      this.saleId,
      this.staffFullName,
      this.zalo,
      this.isConvert,
      this.pipelineCode,
      this.pipelineName,
      this.journeyCode,
      this.journeyName,
      this.dateLastCare,
      this.tag,
      this.diffDay,
      this.relatedWork,
      this.appointment, this.selected});

  ListCustomLeadItems.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    customerSource = json['customer_source'];
    customerSourceName = json['customer_source_name'];
    customerLeadId = json['customer_lead_id'];
    customerLeadCode = json['customer_lead_code'];
    leadFullName = json['lead_full_name'];
    birthday = json['birthday'];
    phone = json['phone'];
    customerType = json['customer_type'];
    saleId = json['sale_id'];
    staffFullName = json['staff_full_name'];
    zalo = json['zalo'];
    isConvert = json['is_convert'];
    pipelineCode = json['pipeline_code'];
    pipelineName = json['pipeline_name'];
    journeyCode = json['journey_code'];
    journeyName = json['journey_name'];
    dateLastCare = json['date_last_care'];
    if (json['tag'] != null) {
      tag = <Tag>[];
      json['tag'].forEach((v) {
        tag!.add(new Tag.fromJson(v));
      });
    }
    diffDay = json['diff_day'];
    relatedWork = json['related_work'];
    appointment = json['appointment'];
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['customer_source'] = this.customerSource;
    data['customer_source_name'] = this.customerSourceName;
    data['customer_lead_id'] = this.customerLeadId;
    data['customer_lead_code'] = this.customerLeadCode;
    data['lead_full_name'] = this.leadFullName;
    data['birthday'] = this.birthday;
    data['phone'] = this.phone;
    data['customer_type'] = this.customerType;
    data['sale_id'] = this.saleId;
    data['staff_full_name'] = this.staffFullName;
    data['zalo'] = this.zalo;
    data['is_convert'] = this.isConvert;
    data['pipeline_code'] = this.pipelineCode;
    data['pipeline_name'] = this.pipelineName;
    data['journey_code'] = this.journeyCode;
    data['journey_name'] = this.journeyName;
    data['date_last_care'] = this.dateLastCare;
    if (this.tag != null) {
      data['tag'] = this.tag!.map((v) => v.toJson()).toList();
    }
    data['diff_day'] = this.diffDay;
    data['related_work'] = this.relatedWork;
    data['appointment'] = this.appointment;
    data['selected'] = this.selected;
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