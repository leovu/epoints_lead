class ListCustomLeadModelRequest {
  String search;
  int page;
  String statusAssign;
  String customerType;
  String tagId;
  String customerSourceName;
  String isConvert;
  String staffFullName;
  String pipelineName;
  String journeyName;
  String createdAt;
  String allocationDate;

  ListCustomLeadModelRequest(
      {this.search,
      this.page,
      this.statusAssign,
      this.customerType,
      this.tagId,
      this.customerSourceName,
      this.isConvert,
      this.staffFullName,
      this.pipelineName,
      this.journeyName,
      this.createdAt,
      this.allocationDate});

  ListCustomLeadModelRequest.fromJson(Map<String, dynamic> json) {
    search = json['search'] ?? "";
    page = json['page'] ?? 1;
    statusAssign = json['status_assign'] ?? "";
    customerType = json['customer_type'] ?? "";
    tagId = json['tag_id'] ?? "";
    customerSourceName = json['customer_source_name'] ?? "";
    isConvert = json['is_convert'] ?? "";
    staffFullName = json['staff_full_name'] ?? "";
    pipelineName = json['pipeline_name'] ?? "";
    journeyName = json['journey_name'] ?? "";
    createdAt = json['created_at'] ?? "";
    allocationDate = json['allocation_date'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['page'] = this.page;
    data['status_assign'] = this.statusAssign;
    data['customer_type'] = this.customerType;
    data['tag_id'] = this.tagId;
    data['customer_source_name'] = this.customerSourceName;
    data['is_convert'] = this.isConvert;
    data['staff_full_name'] = this.staffFullName;
    data['pipeline_name'] = this.pipelineName;
    data['journey_name'] = this.journeyName;
    data['created_at'] = this.createdAt;
    data['allocation_date'] = this.allocationDate;
    return data;
  }
}