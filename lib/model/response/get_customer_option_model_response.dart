class GetCustomerOptionModelReponse {
  int? errorCode;
  String? errorDescription;
  CustomerOptionData? data;

  GetCustomerOptionModelReponse(
      {this.errorCode, this.errorDescription, this.data});

  GetCustomerOptionModelReponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    data = json['Data'] != null ? new CustomerOptionData.fromJson(json['Data']) : null;
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

class CustomerOptionData {
  CustomerOptionType? customerType;
  List<CustomerOptionSource>? source;

  CustomerOptionData({this.customerType, this.source});

  CustomerOptionData.fromJson(Map<String, dynamic> json) {
    customerType = json['Customer_type'] != null
        ? new CustomerOptionType.fromJson(json['Customer_type'])
        : null;
    if (json['Source'] != null) {
      source = <CustomerOptionSource>[];
      json['Source'].forEach((v) {
        source!.add(new CustomerOptionSource.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customerType != null) {
      data['Customer_type'] = this.customerType!.toJson();
    }
    if (this.source != null) {
      data['Source'] = this.source!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerOptionType {
  String? personal;
  String? business;

  CustomerOptionType({this.personal, this.business});

  CustomerOptionType.fromJson(Map<String, dynamic> json) {
    personal = json['personal'];
    business = json['business'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personal'] = this.personal;
    data['business'] = this.business;
    return data;
  }
}

class CustomerOptionSource {
  int? customerSourceId;
  String? sourceName;
  String? customerSourceType;
  bool? selected;

  CustomerOptionSource({this.customerSourceId, this.sourceName, this.customerSourceType, this.selected});

  CustomerOptionSource.fromJson(Map<String, dynamic> json) {
    customerSourceId = json['customer_source_id'];
    sourceName = json['Source_name'];
    customerSourceType = json['customer_source_type'];
    selected = json['selected'] ?? false;;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_source_id'] = this.customerSourceId;
    data['Source_name'] = this.sourceName;
    data['customer_source_type'] = this.customerSourceType;
    data['selected'] = this.selected;
    return data;
  }
}