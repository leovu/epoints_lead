class GenderModel {
  String genderName;
  String genderEnName;
  int genderID;
  bool selected;

  GenderModel({this.genderName,this.genderEnName, this.genderID, this.selected});

  factory GenderModel.fromJson(Map<String, dynamic> parsedJson) {
    return GenderModel(
        genderName: parsedJson['genderName'],
        genderEnName: parsedJson['genderEnName'],
        genderID: parsedJson['genderID'],
        selected: parsedJson['selected']);
  }
}