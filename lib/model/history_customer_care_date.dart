class HistoryCareDateModel {
  String historyCareDateName;
  int historyCareDateID;
  bool selected;

  HistoryCareDateModel({this.historyCareDateName, this.historyCareDateID, this.selected});

  factory HistoryCareDateModel.fromJson(Map<String, dynamic> parsedJson) {
    return HistoryCareDateModel(
        historyCareDateName: parsedJson['historyCareDateName'],
        historyCareDateID: parsedJson['historyCareDateID'],
        selected: parsedJson['selected']);
  }
}