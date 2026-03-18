import 'package:flutter/widgets.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/response/care_lead_response_model.dart';
import 'package:lead_plugin_epoint/model/response/get_status_work_response_model.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../../../../widget/widget.dart';

class ListCustomerCareBloc extends BaseBloc {

  ListCustomerCareBloc(BuildContext context){
    setContext(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _streamStatusWorkData = BehaviorSubject<List<CustomDropdownModel>?>();
   ValueStream<List<CustomDropdownModel>?> get outputStatusWorkData => _streamStatusWorkData.stream;
  setStatusWorkData(List<CustomDropdownModel>? event) => set(_streamStatusWorkData, event);

    final _streamCareLead = BehaviorSubject<List<CareLeadData>?>();
  ValueStream<List<CareLeadData>?> get outputCarLead => _streamCareLead.stream;
  setCareLead(List<CareLeadData>? event) => set(_streamCareLead, event);

  List<CustomDropdownModel>? statusWorkData;
  CustomDropdownModel? statusWorkDataSelected;

  getStatusWork() async {
    try {
      var statusWorkModel = await LeadConnection.getStatusWork(context!);
     List<GetStatusWorkData> model = statusWorkModel?.data ?? [];
     statusWorkData = convertToDropdownModel(model);
      setStatusWorkData(convertToDropdownModel(model));
    } catch (e) {
      // Handle any errors if necessary
      setStatusWorkData([]);
    }
  }

  List<CustomDropdownModel> convertToDropdownModel(List<GetStatusWorkData> statusWorkDataList) {
  return statusWorkDataList.map((statusWorkData) {
    return CustomDropdownModel(
      id: statusWorkData.manageStatusId,
      text: statusWorkData.manageStatusName,
      color: HexColor(statusWorkData.manageStatusColor),
      data: statusWorkData,
    );
  }).toList();
}
  List<CareLeadData>? listCareLead;

  onChange(CustomDropdownModel value) {
    statusWorkDataSelected = value;
    setCareLead(listCareLead?.where((element) => element.manageStatusId == value.id).toList() ?? []);
    setStatusWorkData(statusWorkData);
  }

  onRemove() {
    statusWorkDataSelected = null;
    setCareLead(listCareLead ?? []);
    setStatusWorkData(statusWorkData);
  }
}


class HexColor extends Color {
  static int getColorFromHex(String? hexColor) {
    if((hexColor ?? "") == ""){
      hexColor = "000000";
    }
    hexColor = hexColor!.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String? hexColor) : super(getColorFromHex(hexColor));
}