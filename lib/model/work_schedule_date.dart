class WorkScheduleModel {
  String workscheduleDateName;
  int workscheduleDateID;
  bool selected;

  WorkScheduleModel({this.workscheduleDateName, this.workscheduleDateID, this.selected});

  factory WorkScheduleModel.fromJson(Map<String, dynamic> parsedJson) {
    return WorkScheduleModel(
        workscheduleDateName: parsedJson['workscheduleDateName'],
        workscheduleDateID: parsedJson['workscheduleDateID'],
        selected: parsedJson['selected']);
  }
}