// import 'package:epoints_task_manager_mobile/common/globals.dart';
// import 'package:epoints_task_manager_mobile/common/lang_key.dart';
// import 'package:epoints_task_manager_mobile/common/localization/app_localizations.dart';
// import 'package:epoints_task_manager_mobile/data/local/shared_prefs/shared_prefs_key.dart';
// import 'package:epoints_task_manager_mobile/data/models/base/customer_create_contact_model.dart';
// import 'package:epoints_task_manager_mobile/data/models/base/response_model.dart';
// import 'package:epoints_task_manager_mobile/data/models/request/customer_staff_title_request_model.dart';
// import 'package:epoints_task_manager_mobile/data/models/response/customer_staff_title_response_model.dart';
// import 'package:epoints_task_manager_mobile/presentation/interface/base_bloc.dart';
// import 'package:epoints_task_manager_mobile/presentation/utils/custom_navigator.dart';
// import 'package:epoints_task_manager_mobile/presentation/widgets/widget.dart';
// import 'package:flutter/material.dart';
// import 'package:rxdart/rxdart.dart';

// class CreateContactBloc extends BaseBloc {
//   CreateContactBloc(BuildContext context) {
//     setContext(context);
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _streamPositionModels.close();
//     _streamPositionModel.close();
//     super.dispose();
//   }

//   List<CustomDropdownModel>? positionModels;
//   CustomDropdownModel? positionModel;

//   final FocusNode focusName = FocusNode();
//   final TextEditingController controllerName = TextEditingController();
//   final FocusNode focusPhone = FocusNode();
//   final TextEditingController controllerPhone = TextEditingController();
//   final FocusNode focusEmail = FocusNode();
//   final TextEditingController controllerEmail = TextEditingController();

//   final _streamPositionModels = BehaviorSubject<List<CustomDropdownModel>?>();
//   ValueStream<List<CustomDropdownModel>?> get outputPositionModels =>
//       _streamPositionModels.stream;
//   setPositionModels(List<CustomDropdownModel>? event) =>
//       set(_streamPositionModels, event);

//   final _streamPositionModel = BehaviorSubject<CustomDropdownModel?>();
//   ValueStream<CustomDropdownModel?> get outputPositionModel =>
//       _streamPositionModel.stream;
//   setPositionModel(CustomDropdownModel? event) =>
//       set(_streamPositionModel, event);

//   Future onRefresh({bool isRefresh = true}){
//     return customerStaffTitle();
//   }

//   onConfirm() {
//     if (controllerName.text.trim().isEmpty ||
//         controllerPhone.text.trim().isEmpty) {
//       CustomNavigator.showCustomAlertDialog(
//           context!,
//           AppLocalizations.text(LangKey.notification),
//           AppLocalizations.text(LangKey.customer_create_contact_error));
//       return;
//     }
//     CustomNavigator.pop(context,
//         object: CustomerCreateContactModel(
//             name: controllerName.text,
//             phone: controllerPhone.text,
//             email: controllerEmail.text,
//             positionModel: positionModel));
//   }

//   customerStaffTitle() async {
//     if ((positionModels?.isNotEmpty ?? false)) {
//       return;
//     }
//     ResponseModel response = await repository.customerStaffTitle(context, CustomerStaffTitleRequestModel(
//       brandCode: Globals.prefs.getString(SharedPrefsKey.brand_code)
//     ));
//     if (response.success!) {
//       var responseModel = CustomerStaffTitleResponseModel.fromJson(response.datas);

//       positionModels = (responseModel.data ?? <CustomerStaffTitleModel>[]).map((e) => CustomDropdownModel(
//           id: e.staffTitleId,
//           text: e.staffTitleName
//       )).toList();
//     } else {
//       positionModels = [];
//     }

//     setPositionModels(positionModels);
//   }
// }
