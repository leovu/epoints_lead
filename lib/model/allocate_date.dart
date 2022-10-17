class AllocateDateModel {
  String allocateDateName;
  int allocateDateID;
  bool selected;

  AllocateDateModel({this.allocateDateName, this.allocateDateID, this.selected});

  factory AllocateDateModel.fromJson(Map<String, dynamic> parsedJson) {
    return AllocateDateModel(
        allocateDateName: parsedJson['allocateDateName'],
        allocateDateID: parsedJson['allocateDateID'],
        selected: parsedJson['selected']);
  }
}