class GetCustomerGroupModelResponse {
  int? errorCode;
  String? errorDescription;
  List<CustomerGroupData>? data;

  GetCustomerGroupModelResponse(
      {this.errorCode, this.errorDescription, this.data});

  GetCustomerGroupModelResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <CustomerGroupData>[];
      json['Data'].forEach((v) {
        data!.add(new CustomerGroupData.fromJson(v));
      });
    }
  }

   GetCustomerGroupModelResponse.fromList(List<dynamic>? json) {
    if (json != null) {
      data = <CustomerGroupData>[];
      json.forEach((v) {
        data!.add(new CustomerGroupData.fromJson(v));
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

class CustomerGroupData {
  int? customerGroupId;
  String? groupName;
  int? isDefault;
   bool? selected;


  CustomerGroupData({this.customerGroupId, this.groupName, this.isDefault, this.selected});

  CustomerGroupData.fromJson(Map<String, dynamic> json) {
    customerGroupId = json['customer_group_id'];
    groupName = json['group_name'];
    isDefault = json['is_default'];
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_group_id'] = this.customerGroupId;
    data['group_name'] = this.groupName;
    data['is_default'] = this.isDefault;
    return data;
  }
}
