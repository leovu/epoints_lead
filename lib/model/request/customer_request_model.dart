class CustomerRequestModel {
  String? search;
  int? page;
  String? brandCode;
  String? view;

  CustomerRequestModel({this.search, this.page, this.brandCode, this.view});

  CustomerRequestModel.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    page = json['page'];
    brandCode = json['brand_code'];
    view = json['view'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['page'] = this.page;
    data['brand_code'] = this.brandCode;
    data['view'] = this.view;
    return data;
  }
}