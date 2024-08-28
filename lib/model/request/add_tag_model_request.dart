class AddTagModelRequest {
  String? name;

  AddTagModelRequest({this.name});

  AddTagModelRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class AddPhoneModelRequest {
  String? phone;

  AddPhoneModelRequest({this.phone});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    return data;
  }
}
