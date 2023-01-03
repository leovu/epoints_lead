class TypeOfWorkModel {
  String typeName;
  bool selected;

  TypeOfWorkModel({this.typeName, this.selected});

  factory TypeOfWorkModel.fromJson(Map<String, dynamic> parsedJson) {
    return TypeOfWorkModel(
        typeName: parsedJson['typeName'],
        selected: parsedJson['selected']);
  }
}