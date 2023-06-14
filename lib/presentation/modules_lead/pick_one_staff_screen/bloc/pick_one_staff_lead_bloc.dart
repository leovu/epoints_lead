import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/request/get_list_staff_request_model.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/model/response/work_list_branch_responese_model.dart';
import 'package:lead_plugin_epoint/model/response/work_list_department_response_model.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/widget/custom_dropdown.dart';
import 'package:rxdart/rxdart.dart';

class PickOneStaffBloc extends BaseBloc {
  PickOneStaffBloc(BuildContext context, List<WorkListStaffModel>? models,
      List<WorkListStaffModel>? staffs) {
    setContext(context);

    if (staffs != null) {
      _models = []
        ..addAll(staffs.map((e) => WorkListStaffModel.fromJson(e.toJson())));
      _handleStaffs(models, _models);

      setModels(_models);
    }
  }

  @override
  void dispose() {
    _streamModels.close();
    _streamBranchModels.close();
    _streamBranchModel.close();
    _streamDepartmentModels.close();
    _streamDepartmentModel.close();
    super.dispose();
  }

  List<WorkListStaffModel>? _models;
  List<CustomDropdownModel> _branchModels = [
    CustomDropdownModel(text: AppLocalizations.text(LangKey.all))
  ];
  CustomDropdownModel? branchModel;
  List<CustomDropdownModel> _departmentModels = [
    CustomDropdownModel(text: AppLocalizations.text(LangKey.all))
  ];
  CustomDropdownModel? departmentModel;

  final _streamModels = BehaviorSubject<List<WorkListStaffModel>?>();
  ValueStream<List<WorkListStaffModel>?> get outputModels =>
      _streamModels.stream;
  setModels(List<WorkListStaffModel>? event) => set(_streamModels, event);

  final _streamBranchModels = BehaviorSubject<List<CustomDropdownModel>?>();
  ValueStream<List<CustomDropdownModel>?> get outputBranchModels =>
      _streamBranchModels.stream;
  setBranchModels(List<CustomDropdownModel> event) =>
      set(_streamBranchModels, event);

  final _streamBranchModel = BehaviorSubject<CustomDropdownModel?>();
  ValueStream<CustomDropdownModel?> get outputBranchModel =>
      _streamBranchModel.stream;
  setBranchModel(CustomDropdownModel? event) => set(_streamBranchModel, event);

  final _streamDepartmentModels = BehaviorSubject<List<CustomDropdownModel>?>();
  ValueStream<List<CustomDropdownModel>?> get outputDepartmentModels =>
      _streamDepartmentModels.stream;
  setDepartmentModels(List<CustomDropdownModel> event) =>
      set(_streamDepartmentModels, event);

  final _streamDepartmentModel = BehaviorSubject<CustomDropdownModel?>();
  ValueStream<CustomDropdownModel?> get outputDepartmentModel =>
      _streamDepartmentModel.stream;
  setDepartmentModel(CustomDropdownModel? event) =>
      set(_streamDepartmentModel, event);

  search(String event) {
    List<WorkListStaffModel>? events;
    try {
      if (branchModel?.id == null) {
        events = _models;
      } else {
        events = _models!
            .where((element) => element.branchId == branchModel!.id)
            .toList();
      }
    } catch (_) {}

    try {
      if (departmentModel?.id != null) {
        events = _models!
            .where((element) => element.departmentId == departmentModel!.id)
            .toList();
      }
    } catch (_) {}

    if (event.isEmpty || (events?.length ?? 0) == 0) {
      setModels(events);
    } else {
      List<WorkListStaffModel>? results;
      try {
        results = events!.where((model) {
          List<String> searchs = event.toLowerCase().removeAccents().split(" ");
          bool result = true;
          for (String element in searchs) {
            if (!((model.staffName ?? "")
                .toLowerCase()
                .removeAccents()
                .contains(element))) {
              result = false;
              break;
            }
          }

          return result;
        }).toList();
      } catch (_) {}

      setModels(results ?? []);
    }
  }

  selected(List<WorkListStaffModel> models, WorkListStaffModel model) {


    try{
      final event = models.firstWhere((element) => element.isSelected!);
      event.isSelected = false;
    }
    catch(_){}

    model.isSelected = true;
    setModels(models);

    
  }

  selectAll(List<WorkListStaffModel> models) {
    for (var e in models ?? <WorkListStaffModel>[]) {
      e.isSelected = true;
    }
    setModels(models);
  }

  delete(String event) {
    try {
      var results = _models!.where((element) => element.isSelected!).toList();
      if (results != null) {
        for (var e in results) {
          e.isSelected = false;
        }
      }
    } catch (_) {}

    search(event);
  }

  confirm(List<WorkListStaffModel> events) {
    List<WorkListStaffModel> models = [];
    try {
      var results = events.where((element) => element.isSelected!).toList();
      if (results != null) {
        models = results;
      }
    } catch (_) {}

    Navigator.of(context!).pop(models);
  }

  workListStaff(List<WorkListStaffModel>? models, String event, int? id) async {
    if ((_models?.length ?? 0) != 0) {
      models = [];
      try {
        var results = _models!.where((element) => element.isSelected!).toList();
        if ((results?.length ?? 0) != 0) {
          models = results;
        }
      } catch (_) {}
    }
    var response = await LeadConnection.workListStaff(
        context, WorkListStaffRequestModel(manageProjectId: id));
    if (response != null) {
      _models = response.data ?? [];

      _handleStaffs(models, _models);
    } else {
      _models = [];
    }

    search(event);
  }

  workListBranch() async {
    var responseModel = await LeadConnection.workListBranch(context);

    if (responseModel != null) {
      _branchModels = [
        CustomDropdownModel(text: AppLocalizations.text(LangKey.all))
      ];
      _branchModels.addAll((responseModel.data ?? <WorkListBranchModel>[])
          .map((e) => CustomDropdownModel(id: e.branchId, text: e.branchName)));
    }

    setBranchModels(_branchModels);
    branchModel =
        _branchModels.firstWhere((element) => element.id == branchModel?.id);
    setBranchModel(branchModel);
  }

  workListDepartment() async {
    var response = await LeadConnection.workListDepartment(context);
    if (response != null) {
      _departmentModels = [
        CustomDropdownModel(text: AppLocalizations.text(LangKey.all))
      ];
      _departmentModels.addAll((response.data ?? <WorkListDepartmentModel>[])
          .map((e) =>
              CustomDropdownModel(id: e.departmentId, text: e.departmentName)));
    }

    setDepartmentModels(_departmentModels);
    departmentModel = _departmentModels
        .firstWhere((element) => element.id == departmentModel?.id);
    setDepartmentModel(departmentModel);
  }

  _handleStaffs(
      List<WorkListStaffModel>? models, List<WorkListStaffModel>? staffs) {
    if ((models?.length ?? 0) != 0) {
      for (var e in models!) {
        try {
          var result =
              staffs!.firstWhere((element) => element.staffId == e.staffId);
          if (result != null) {
            result.isSelected = true;
          }
        } catch (_) {}
      }
    }
  }
}
