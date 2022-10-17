class GetTagModelReponse {
  int errorCode;
  String errorDescription;
  List<TagData> data;

  GetTagModelReponse({this.errorCode, this.errorDescription, this.data});

  GetTagModelReponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <TagData>[];
      json['Data'].forEach((v) {
        data.add(new TagData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDescription'] = this.errorDescription;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TagData {
  int tagId;
  String keyword;
  String name;
  bool selected;

  TagData({this.tagId, this.keyword, this.name,  this.selected});

  TagData.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'] ;
    keyword = json['keyword'];
    name = json['name'];
    selected = json['selected'] ?? false;;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag_id'] = this.tagId;
    data['keyword'] = this.keyword;
    data['name'] = this.name;
    data['selected'] = this.selected;
    return data;
  }
}
