// import 'dart:io';
// import 'package:collection/collection.dart';
// import 'package:epoints_task_manager_mobile/common/constant.dart';
// import 'package:epoints_task_manager_mobile/common/globals.dart';
// import 'package:epoints_task_manager_mobile/common/lang_key.dart';
// import 'package:epoints_task_manager_mobile/common/localization/app_localizations.dart';
// import 'package:epoints_task_manager_mobile/common/theme.dart';
// import 'package:epoints_task_manager_mobile/data/models/base/filter_model.dart';
// import 'package:epoints_task_manager_mobile/data/models/base/response_model.dart';
// import 'package:epoints_task_manager_mobile/data/models/request/customer_work_store_request_model.dart';
// import 'package:epoints_task_manager_mobile/data/models/response/customer_detail_response_model.dart';
// import 'package:epoints_task_manager_mobile/data/models/response/customer_result_work_response_model.dart';
// import 'package:epoints_task_manager_mobile/data/models/response/customer_type_work_response_model.dart';
// import 'package:epoints_task_manager_mobile/data/models/response/customer_work_response_model.dart';
// import 'package:epoints_task_manager_mobile/data/network/http/aws_connection.dart';
// import 'package:epoints_task_manager_mobile/presentation/interface/base_bloc.dart';
// import 'package:epoints_task_manager_mobile/presentation/utils/custom_document_picker.dart';
// import 'package:epoints_task_manager_mobile/presentation/utils/custom_navigator.dart';
// import 'package:epoints_task_manager_mobile/presentation/utils/ultility.dart';
// import 'package:epoints_task_manager_mobile/presentation/widgets/widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// import 'package:rxdart/rxdart.dart';

// class CreateCareBloc extends BaseBloc {
//   CreateCareBloc(BuildContext context) {
//     setContext(context);
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _streamTypeModels.close();
//     _streamTypeModel.close();
//     _streamResultModels.close();
//     _streamResultModel.close();
//     _streamFiles.close();
//     _streamStaffAppointment.close();
//     _streamDate.close();
//     _streamTimeModels.close();
//     super.dispose();
//   }

//   late CustomerDetailResponseModel model;
//   CustomerWorkModel? workModel;
//   List<CustomDropdownModel>? typeModels, resultModels;
//   CustomDropdownModel? typeModel, resultModel;
//   List<CustomerWorkDocumentModel> files = [];
//   bool staffAppointment = false;
//   DateTime date = DateTime.now();
//   List<FilterModel> timeModels = [
//     FilterModel(
//         text: AppLocalizations.text(LangKey.do_not_remind), selected: true),
//     FilterModel(
//       id: timePrevious10,
//       text: "10 ${AppLocalizations.text(LangKey.minutes)}",
//     ),
//     FilterModel(
//       id: timePrevious15,
//       text: "15 ${AppLocalizations.text(LangKey.minutes)}",
//     ),
//     FilterModel(
//       id: timePrevious30,
//       text: "30 ${AppLocalizations.text(LangKey.minutes)}",
//     ),
//     FilterModel(
//       id: timePrevious60,
//       text: "60 ${AppLocalizations.text(LangKey.minutes)}",
//     ),
//   ];

//   final FocusNode focusTitle = FocusNode();
//   final TextEditingController controllerTitle = TextEditingController();

//   final FocusNode focusNote = FocusNode();
//   final TextEditingController controllerNote = TextEditingController();

//   final FocusNode focusAppointmentNote = FocusNode();
//   final TextEditingController controllerAppointmentNote =
//       TextEditingController();

//   final _streamTypeModels = BehaviorSubject<List<CustomDropdownModel>?>();
//   ValueStream<List<CustomDropdownModel>?> get outputTypeModels =>
//       _streamTypeModels.stream;
//   setTypeModels(List<CustomDropdownModel>? event) =>
//       set(_streamTypeModels, event);

//   final _streamTypeModel = BehaviorSubject<CustomDropdownModel?>();
//   ValueStream<CustomDropdownModel?> get outputTypeModel =>
//       _streamTypeModel.stream;
//   setTypeModel(CustomDropdownModel? event) => set(_streamTypeModel, event);

//   final _streamResultModels = BehaviorSubject<List<CustomDropdownModel>?>();
//   ValueStream<List<CustomDropdownModel>?> get outputResultModels =>
//       _streamResultModels.stream;
//   setResultModels(List<CustomDropdownModel>? event) =>
//       set(_streamResultModels, event);

//   final _streamResultModel = BehaviorSubject<CustomDropdownModel?>();
//   ValueStream<CustomDropdownModel?> get outputResultModel =>
//       _streamResultModel.stream;
//   setResultModel(CustomDropdownModel? event) => set(_streamResultModel, event);

//   final _streamFiles = BehaviorSubject<List<CustomerWorkDocumentModel>>();
//   ValueStream<List<CustomerWorkDocumentModel>> get outputFiles =>
//       _streamFiles.stream;
//   setFiles(List<CustomerWorkDocumentModel> event) => set(_streamFiles, event);

//   final _streamStaffAppointment = BehaviorSubject<bool>();
//   ValueStream<bool> get outputStaffAppointment =>
//       _streamStaffAppointment.stream;
//   setStaffAppointment(bool event) => set(_streamStaffAppointment, event);

//   final _streamDate = BehaviorSubject<DateTime>();
//   ValueStream<DateTime> get outputDate => _streamDate.stream;
//   setDate(DateTime event) => set(_streamDate, event);

//   final _streamTimeModels = BehaviorSubject<List<FilterModel>>();
//   ValueStream<List<FilterModel>> get outputTimeModels =>
//       _streamTimeModels.stream;
//   setTimeModels(List<FilterModel> event) => set(_streamTimeModels, event);

//   Future onRefresh({bool isRefresh = true}) {
//     final group = <Future>[];
//     group.add(customerTypeWork());
//     group.add(customerResultWork());
//     return Future.wait(group);
//   }

//   onUploadFile() async {
//     List<File>? events = await CustomDocumentPicker.openMultiDocument(context);
//     if (events == null) {
//       return;
//     }
//     CustomNavigator.showProgressDialog(context);
//     String? error;
//     for (var e in events) {
//       await uploadFile(
//           AWSFileModel(
//             file: e,
//           ), (url) {
//         files.add(CustomerWorkDocumentModel(
//             fileName: getNameFromPath(url), path: url));
//       }, (e) => error = e);
//     }
//     CustomNavigator.hideProgressDialog();
//     setFiles(files);

//     if (error != null) {
//       CustomNavigator.showCustomAlertDialog(
//           context!, AppLocalizations.text(LangKey.notification), error);
//     }
//   }

//   onRemoveFile(CustomerWorkDocumentModel model) {
//     files.remove(model);
//     setFiles(files);
//   }

//   onSave() {
//     customerWorkStore(CustomerWorkStoreRequestModel(
//       manageWorkId: workModel?.manageWorkId,
//       customerId: model.customerId,
//       manageWorkCustomerType: model.customerType,
//       manageTypeWorkId: typeModel?.id,
//       manageWorkTitle: controllerTitle.text,
//       manageResultId: resultModel?.id,
//       description: controllerNote.text,
//       listDocument: files.map((e) => e.path ?? "").toList(),
//       remindWork: staffAppointment ? CustomerWorkStoreRemindModel(
//         dateRemind: formatDate(date, format: AppFormat.formatDateResponse),
//         time: timeModels.firstWhere((element) => element.selected).id,
//         timeType: timeMinute,
//         description: controllerAppointmentNote.text
//       ) : null
//     ));
//   }

//   onExit() {
//     CustomNavigator.pop(context);
//   }

//   uploadFile(AWSFileModel model, Function(String) onSuccess,
//       Function(String) onError) async {
//     ResponseModel response =
//         await repository.upload(context, model, showError: false);
//     if (response.success!) {
//       onSuccess(response.url ?? "");
//     } else {
//       onError(response.errorDescription ?? "");
//     }
//   }

//   onStaffAppointment(bool? event) {
//     staffAppointment = event!;
//     setStaffAppointment(staffAppointment);
//   }

//   onShowDate() {
//     DateTime now = DateTime.now();
//     DatePicker.showDatePicker(context!,
//         minTime: minDateTime,
//         maxTime: now.add(Duration(days: 365)),
//         currentTime: date,
//         locale: Globals.localeType, onConfirm: (event) {
//       DatePicker.showTimePicker(context!,
//           locale: Globals.localeType,
//           showSecondsColumn: false,
//           currentTime: date, onConfirm: (time) {
//         setDate(DateTime(
//             event.year, event.month, event.day, time.hour, time.minute));
//       });
//     });
//   }

//   onTime(FilterModel model) {
//     if (model.selected) {
//       return;
//     }

//     var result = timeModels.firstWhereOrNull((element) => element.selected);
//     if (result != null) {
//       result.selected = false;
//     }

//     model.selected = true;

//     setTimeModels(timeModels);
//   }

//   customerTypeWork() async {
//     if ((typeModels?.isNotEmpty ?? false)) {
//       return;
//     }
//     ResponseModel response = await repository.customerTypeWork(context);
//     if (response.success!) {
//       var responseModel =
//           CustomerTypeWorkResponseModel.fromJson(response.datas);

//       typeModels = (responseModel.data ?? <CustomerTypeWorkModel>[])
//           .map((e) => CustomDropdownModel(
//               id: e.manageTypeWorkId, text: e.manageTypeWorkName))
//           .toList();
//     } else {
//       typeModels = [];
//     }

//     setTypeModels(typeModels);
//   }

//   customerResultWork() async {
//     if ((resultModels?.isNotEmpty ?? false)) {
//       return;
//     }
//     ResponseModel response = await repository.customerResultWork(context);
//     if (response.success!) {
//       var responseModel =
//           CustomerResultWorkResponseModel.fromJson(response.datas);

//       resultModels = (responseModel.data ?? <CustomerResultWorkModel>[])
//           .map((e) => CustomDropdownModel(
//               id: e.manageResultId, text: e.manageResultName))
//           .toList();
//     } else {
//       resultModels = [];
//     }

//     setResultModels(resultModels);
//   }

//   customerWorkStore(CustomerWorkStoreRequestModel model) async {
//     CustomNavigator.showProgressDialog(context);
//     ResponseModel response = workModel == null
//         ? await repository.customerWorkStore(context, model)
//         : await repository.customerWorkEdit(context, model);
//     CustomNavigator.hideProgressDialog();
//     if (response.success!) {
//       await CustomNavigator.showCustomAlertDialog(
//           context!,
//           AppLocalizations.text(LangKey.notification),
//           response.errorDescription ?? "");

//       CustomNavigator.pop(context, object: true);
//     }
//   }
// }
