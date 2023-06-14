class CustomerTypeModel {
  String? customerTypeName;
  int? customerTypeID;
  bool? selected;

  CustomerTypeModel({this.customerTypeName, this.customerTypeID, this.selected});

  factory CustomerTypeModel.fromJson(Map<String, dynamic> parsedJson) {
    return CustomerTypeModel(
        customerTypeName: parsedJson['customerTypeName'],
        customerTypeID: parsedJson['customerTypeID'],
        selected: parsedJson['selected']);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['customerTypeName'] = this.customerTypeName;
  //   data['customerTypeID'] = this.customerTypeID;
  //   data['selected'] = this.selected;
  //   return data;
  // }
}