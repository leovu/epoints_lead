class GetJourneyModelRequest {
  List<String?>? pipelineCode;

  GetJourneyModelRequest({this.pipelineCode});

  GetJourneyModelRequest.fromJson(Map<String, dynamic> json) {
    pipelineCode = json['pipeline_code'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pipeline_code'] = this.pipelineCode;
    return data;
  }
}
