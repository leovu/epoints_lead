class ListNoteResponseModel {
  int? errorCode;
  String? errorDescription;
  List<NoteData>? data;

  ListNoteResponseModel({this.errorCode, this.errorDescription, this.data});

  ListNoteResponseModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <NoteData>[];
      json['Data'].forEach((v) {
        data!.add(new NoteData.fromJson(v));
      });
    }
  }

  ListNoteResponseModel.fromList(List<dynamic>? json) {
    if (json != null) {
      data = <NoteData>[];
      json.forEach((v) {
        data!.add(new NoteData.fromJson(v));
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

class NoteData {
  int? customer_lead_note_id;
  String? content;
  String? createdBy;
  String? createdByName;
  String? createdAt;

  NoteData(
      {this.customer_lead_note_id,
      this.content,
      this.createdBy,
      this.createdByName,
      this.createdAt});

  NoteData.fromJson(Map<String, dynamic> json) {
    customer_lead_note_id = json['customer_lead_note_id'];
    content = json['content'];
    createdBy = json['created_by'];
    createdByName = json['created_by_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_deal_note_id'] = this.customer_lead_note_id;
    data['content'] = this.content;
    data['created_by'] = this.createdBy;
    data['created_by_name'] = this.createdByName;
    data['created_at'] = this.createdAt;
    return data;
  }
}


class GetListNoteModel {
  int? customer_lead_id;
  int? page;
  String? brandCode;
  GetListNoteModel({this.customer_lead_id, this.page, this.brandCode});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_id'] = this.customer_lead_id;
    if (this.page != null) {
      data['page'] = this.page;
    }

    if (this.brandCode != null) {
      data['brand_code'] = this.brandCode;
    }
    return data;
  }
}

class GetFileReqModel {
  int? customer_lead_id;

  GetFileReqModel({this.customer_lead_id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_id'] = this.customer_lead_id;
    return data;
  }
}

class CreateNoteReqModel {
  int? customer_lead_id;
  String? content;
  CreateNoteReqModel({this.customer_lead_id, this.content});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_id'] = this.customer_lead_id;
    data['content'] = this.content;

    return data;
  }
}

class UploadFileReqModel {
  int? customer_lead_id;
  String? fileName;
  String? path;
  String? content;

  UploadFileReqModel({this.customer_lead_id, this.fileName, this.path, this.content});

  UploadFileReqModel.fromJson(Map<String, dynamic> json) {
    customer_lead_id = json['deal_id'];
    fileName = json['file_name'];
    path = json['path'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_id'] = this.customer_lead_id;
    data['file_name'] = this.fileName;
    data['path'] = this.path;
    data['content'] = this.content;
    return data;
  }
}

class ListLeadFilesModel {
  int? errorCode;
  String? errorDescription;
  List<LeadFilesModel>? data;

  ListLeadFilesModel({this.errorCode, this.errorDescription, this.data});

  ListLeadFilesModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <LeadFilesModel>[];
      json['Data'].forEach((v) {
        data!.add(new LeadFilesModel.fromJson(v));
      });
    }
  }

  ListLeadFilesModel.fromList(List<dynamic>? json) {
    if (json != null) {
      data = <LeadFilesModel>[];
      json.forEach((v) {
        data!.add(new LeadFilesModel.fromJson(v));
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

class LeadFilesModel {
  int? customer_lead_file_id;
  int? customer_lead_id;
  String? fileName;
  String? path;
  String? content;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;

  LeadFilesModel(
      {this.customer_lead_file_id,
      this.customer_lead_id,
      this.fileName,
      this.path,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy});

  LeadFilesModel.fromJson(Map<String, dynamic> json) {
    customer_lead_file_id = json['deal_file_id'];
    customer_lead_id = json['deal_id'];
    fileName = json['file_name'];
    path = json['path'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deal_file_id'] = this.customer_lead_file_id;
    data['deal_id'] = this.customer_lead_id;
    data['file_name'] = this.fileName;
    data['path'] = this.path;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}
