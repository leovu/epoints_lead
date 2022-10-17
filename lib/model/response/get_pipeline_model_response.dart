class GetPipelineModelReponse {
  int errorCode;
  String errorDescription;
  List<PipelineData> data;

  GetPipelineModelReponse({this.errorCode, this.errorDescription, this.data});

  GetPipelineModelReponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <PipelineData>[];
      json['Data'].forEach((v) {
        data.add(PipelineData.fromJson(v));
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

class PipelineData {
  int pipelineId;
  String pipelineCode;
  String pipelineName;
  String pipelineCategoryCode;
  int ownerId;
  bool selected;

  PipelineData(
      {this.pipelineId,
      this.pipelineCode,
      this.pipelineName,
      this.pipelineCategoryCode,
      this.ownerId,
      this.selected});

  PipelineData.fromJson(Map<String, dynamic> json) {
    pipelineId = json['pipeline_id'];
    pipelineCode = json['pipeline_code'];
    pipelineName = json['pipeline_name'];
    pipelineCategoryCode = json['pipeline_category_code'];
    ownerId = json['owner_id'];
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pipeline_id'] = this.pipelineId;
    data['pipeline_code'] = this.pipelineCode;
    data['pipeline_name'] = this.pipelineName;
    data['pipeline_category_code'] = this.pipelineCategoryCode;
    data['owner_id'] = this.ownerId;
    data['selected'] = this.selected;
    return data;
  }
}