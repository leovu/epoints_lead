class CreateDateModel {
  String? createDateName;
  int? createDateID;
  bool? selected;

  CreateDateModel({this.createDateName, this.createDateID, this.selected});

  factory CreateDateModel.fromJson(Map<String, dynamic> parsedJson) {
    return CreateDateModel(
        createDateName: parsedJson['createDateName'],
        createDateID: parsedJson['createDateID'],
        selected: parsedJson['selected']);
  }
}