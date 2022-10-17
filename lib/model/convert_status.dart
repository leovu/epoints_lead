class ConvertStatusModel {
  String statusName;
  int statusID;
  bool selected;

  ConvertStatusModel({this.statusName, this.statusID, this.selected});

  factory ConvertStatusModel.fromJson(Map<String, dynamic> parsedJson) {
    return ConvertStatusModel(
        statusName: parsedJson['statusName'],
        statusID: parsedJson['statusID'],
        selected: parsedJson['selected']);
  }
}