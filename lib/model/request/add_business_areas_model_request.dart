class AddBusinessAreasModelRequest {
  String name;
  String description;

  AddBusinessAreasModelRequest({this.name, this.description});

  AddBusinessAreasModelRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
