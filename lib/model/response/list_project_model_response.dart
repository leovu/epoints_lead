class ListProjectModelResponse {
  int errorCode;
  String errorDescription;
  ListProjectData data;

  ListProjectModelResponse({this.errorCode, this.errorDescription, this.data});

  ListProjectModelResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    data = json['Data'] != null ? new ListProjectData.fromJson(json['Data']) : null;
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

class ListProjectData {
  PageInfo pageInfo;
  List<ListProjectItems> items;

  ListProjectData({this.pageInfo, this.items});

  ListProjectData.fromJson(Map<String, dynamic> json) {
    pageInfo = ((json['PageInfo'] != null) && (json['PageInfo'] != {}))
        ?  PageInfo.fromJson(json['PageInfo'])
        : null;
    if (json['Items'] != null) {
      items = <ListProjectItems>[];
      json['Items'].forEach((v) {
        items.add(ListProjectItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pageInfo != null ) {
      data['PageInfo'] = this.pageInfo.toJson();
    }
    if (this.items != null) {
      data['Items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PageInfo {
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

  PageInfo(
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

  PageInfo.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    itemPerPage = json['itemPerPage'];
    from = json['from'];
    to = json['to'];
    currentPage = json['currentPage'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    previousPage = json['previousPage'];
    nextPage = json['nextPage'];
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

class ListProjectItems {
  int manageProjectId;
  String manageProjectName;
  String managerAvatar;
  String manager;
  String manageProjectStatusName;
  String manageProjectStatusColor;
  num ratio;
  List<ListProjectTag> tag;
  bool selected;
  ListProjectItems(
      {this.manageProjectId,
      this.manageProjectName,
      this.managerAvatar,
      this.manager,
      this.manageProjectStatusName,
      this.manageProjectStatusColor,
      this.ratio,
      this.tag,
      this.selected});

  ListProjectItems.fromJson(Map<String, dynamic> json) {
    manageProjectId = json['manage_project_id'];
    manageProjectName = json['manage_project_name'];
    managerAvatar = json['manager_avatar'];
    manager = json['manager'];
    manageProjectStatusName = json['manage_project_status_name'];
    manageProjectStatusColor = json['manage_project_status_color'];
    ratio = json['ratio(%)'];
    selected = json['selected'] ?? false;
    if (json['tag'] != null) {
      tag = <ListProjectTag>[];
      json['tag'].forEach((v) {
        tag.add(new ListProjectTag.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manage_project_id'] = this.manageProjectId;
    data['manage_project_name'] = this.manageProjectName;
    data['manager_avatar'] = this.managerAvatar;
    data['manager'] = this.manager;
    data['manage_project_status_name'] = this.manageProjectStatusName;
    data['manage_project_status_color'] = this.manageProjectStatusColor;
    data['ratio(%)'] = this.ratio;
    data['selected'] = this.selected;
    if (this.tag != null) {
      data['tag'] = this.tag.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListProjectTag {
  String manageTagName;

  ListProjectTag({this.manageTagName});

  ListProjectTag.fromJson(Map<String, dynamic> json) {
    manageTagName = json['manage_tag_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manage_tag_name'] = this.manageTagName;
    return data;
  }
}
