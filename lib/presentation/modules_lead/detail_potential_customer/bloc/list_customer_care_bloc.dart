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

    final _streamCareDeal = BehaviorSubject<List<CareLeadData>?>();
  ValueStream<List<CareLeadData>?> get outputCareDeal => _streamCareDeal.stream;
  setCareDeal(List<CareLeadData>? event) => set(_streamCareDeal, event);

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
      data: statusWorkData,
    );
  }).toList();
}
  List<CareLeadData>? listCareDeal;

  onChange(CustomDropdownModel value) {
    statusWorkDataSelected = value;
    setCareDeal(listCareDeal?.where((element) => element.manageStatusId == value.id).toList() ?? []);
    setStatusWorkData(statusWorkData);
  }

  onRemove() {
    statusWorkDataSelected = null;
    setCareDeal(listCareDeal ?? []);
    setStatusWorkData(statusWorkData);
  }
}