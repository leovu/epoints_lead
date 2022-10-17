class ListCustomLeadModelReponse {
  int errorCode;
  String errorDescription;
  ListCustomLeadData data;

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
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class ListCustomLeadData {
  ListCustomLeadPageInfo pageInfo;
  List<ListCustomLeadItems> items;

  ListCustomLeadData({this.pageInfo, this.items});

  ListCustomLeadData.fromJson(Map<String, dynamic> json) {
    pageInfo = json['PageInfo'] != null
        ? new ListCustomLeadPageInfo.fromJson(json['PageInfo'])
        : null;
    if (json['Items'] != null) {
      items = <ListCustomLeadItems>[];
      json['Items'].forEach((v) {
        items.add(new ListCustomLeadItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pageInfo != null) {
      data['PageInfo'] = this.pageInfo.toJson();
    }
    if (this.items != null) {
      data['Items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListCustomLeadPageInfo {
  int total;
  int itemPerPage;
  int from;
  int to;
  int currentPage;
  int firstPage;
  int lastPage;
  int previousPage;
  int nextPage;
  List<int> pageRange;

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
    itemPerPage = json['itemPerPage'] ?? 10;
    from = json['from'] ?? 0;
    to = json['to'] ?? 0;
    currentPage = json['currentPage'] ?? 1;
    firstPage = json['firstPage'] ?? 1;
    lastPage = json['lastPage'] ?? 0;
    previousPage = json['previousPage'] ?? 0;
    nextPage = json['nextPage'] ?? 1;
    pageRange = json['pageRange']?.cast<int>() ?? [];
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
  String avatar;
  String leadFullName;
  String customerType;
  String phone;
  String journeyName;
  String zalo;
  String staffFullName;
  int saleId;
  String tagName;
  String customerSourceName;
  int isConvert;
  String pipelineName;
  String customerLeadCode;
  bool selected;

  ListCustomLeadItems(
      {this.avatar,
      this.leadFullName,
      this.customerType,
      this.phone,
      this.journeyName,
      this.zalo,
      this.staffFullName,
      this.saleId,
      this.tagName,
      this.customerSourceName,
      this.isConvert,
      this.pipelineName,
      this.customerLeadCode,
      this.selected});

  ListCustomLeadItems.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'] ?? "" ;
    leadFullName = json['lead_full_name'] ?? "";
    customerType = json['customer_type'] ?? "";
    phone = json['phone'] ?? "";
    journeyName = json['journey_name'];
    zalo = json['zalo'];
    staffFullName = json['staff_full_name'];
    saleId = json['sale_id'];
    tagName = json['tag_name'];
    customerSourceName = json['customer_source_name'];
    isConvert = json['is_convert'];
    pipelineName = json['pipeline_name'];
    customerLeadCode = json['customer_lead_code'];
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['lead_full_name'] = this.leadFullName;
    data['customer_type'] = this.customerType;
    data['phone'] = this.phone;
    data['journey_name'] = this.journeyName;
    data['zalo'] = this.zalo;
    data['staff_full_name'] = this.staffFullName;
    data['sale_id'] = this.saleId;
    data['tag_name'] = this.tagName;
    data['customer_source_name'] = this.customerSourceName;
    data['is_convert'] = this.isConvert;
    data['pipeline_name'] = this.pipelineName;
    data['customer_lead_code'] = this.customerLeadCode;
    data['selected'] = this.selected;
    return data;
  }
}