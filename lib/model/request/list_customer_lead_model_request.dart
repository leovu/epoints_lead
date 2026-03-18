class ListCustomLeadModelRequest {
  String? search;
  int? page;
  List<int?>? tagId;
  String? customerType;
  String? statusAssign;
  List<int?>? customerSourceId;
  String? createdAt;
  String? allocationDate;
  String? isConvert;
  List<int?>? staffId;
  List<int?>? pipelineId;
  List<int?>? journeyId;
  String? careHistory;

  ListCustomLeadModelRequest(
      {this.search,
      this.page,
      this.tagId,
      this.customerType,
      this.statusAssign,
      this.customerSourceId,
      this.createdAt,
      this.allocationDate,
      this.isConvert,
      this.staffId,
      this.pipelineId,
      this.journeyId,
      this.careHistory});

  ListCustomLeadModelRequest.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    page = json['page'];
    tagId = json['tag_id'];
    customerType = json['customer_type'];
    statusAssign = json['status_assign'];
    customerSourceId = json['customer_source_id'].cast<int>();
    createdAt = json['created_at'];
    allocationDate = json['allocation_date'];
    isConvert = json['is_convert'];
    staffId = json['staff_id'].cast<int>();
    pipelineId = json['pipeline_id'].cast<int>();
    journeyId = json['journey_id'].cast<int>();
    careHistory = json['care_history'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['page'] = this.page;
    data['tag_id'] = this.tagId;
    data['customer_type'] = this.customerType;
    data['status_assign'] = this.statusAssign;
    data['customer_source_id'] = this.customerSourceId;
    data['created_at'] = this.createdAt;
    data['allocation_date'] = this.allocationDate;
    data['is_convert'] = this.isConvert;
    data['staff_id'] = this.staffId;
    data['pipeline_id'] = this.pipelineId;
    data['journey_id'] = this.journeyId;
    data['care_history'] = this.careHistory;
    return data;
  }
}
