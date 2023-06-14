class GetDealModelReponse {
  int? errorCode;
  String? errorDescription;
  List<Data>? data;

  GetDealModelReponse({this.errorCode, this.errorDescription, this.data});

  GetDealModelReponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <Data>[];
      json['Data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? dealId;
  String? dealCode;
  String? dealName;
  String? customerCode;

  Data({this.dealId, this.dealCode, this.dealName, this.customerCode});

  Data.fromJson(Map<String, dynamic> json) {
    dealId = json['deal_id'];
    dealCode = json['deal_code'];
    dealName = json['deal_name'];
    customerCode = json['customer_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['deal_id'] = this.dealId;
    data['deal_code'] = this.dealCode;
    data['deal_name'] = this.dealName;
    data['customer_code'] = this.customerCode;
    return data;
  }
}
