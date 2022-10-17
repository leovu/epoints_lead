class GetJourneyModelReponse {
  int errorCode;
  String errorDescription;
  List<JourneyData> data;

  GetJourneyModelReponse({this.errorCode, this.errorDescription, this.data});

  GetJourneyModelReponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <JourneyData>[];
      json['Data'].forEach((v) {
        data.add(JourneyData.fromJson(v));
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

class JourneyData {
  String journeyCode;
  int journeyId;
  String journeyName;
  int pipelineId;
  String pipelineCode;
  bool selected;

  JourneyData(
      {this.journeyCode,
      this.journeyId,
      this.journeyName,
      this.pipelineId,
      this.pipelineCode, this.selected});

  JourneyData.fromJson(Map<String, dynamic> json) {
    journeyCode = json['journey_code'];
    journeyId = json['journey_id'];
    journeyName = json['journey_name'];
    pipelineId = json['pipeline_id'];
    pipelineCode = json['pipeline_code'];
    selected = json['selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['journey_code'] = this.journeyCode;
    data['journey_id'] = this.journeyId;
    data['journey_name'] = this.journeyName;
    data['pipeline_id'] = this.pipelineId;
    data['pipeline_code'] = this.pipelineCode;
    data['selected'] = this.selected;
    return data;
  }
}