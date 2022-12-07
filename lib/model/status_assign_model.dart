class StatusAssignModel {
  String statusName;
  String statusID;
  bool selected;

  StatusAssignModel({this.statusName, this.statusID, this.selected});

  factory StatusAssignModel.fromJson(Map<String, dynamic> parsedJson) {
    return StatusAssignModel(
        statusName: parsedJson['statusName'],
        statusID: parsedJson['statusID'],
        selected: parsedJson['selected']);
  }
}