class ListProjectModelRequest {
  int? page;
  String? search;

  ListProjectModelRequest({this.page, this.search});

  ListProjectModelRequest.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    search = json['search'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['search'] = this.search;
    return data;
  }
}
