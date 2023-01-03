class TypeCardModel {
  String name;
  int id;
  bool selected;

  TypeCardModel({this.name, this.id, this.selected});

  factory TypeCardModel.fromJson(Map<String, dynamic> parsedJson) {
    return TypeCardModel(
        name: parsedJson['name'],
        id: parsedJson['id'],
        selected: parsedJson['selected']);
  }
}