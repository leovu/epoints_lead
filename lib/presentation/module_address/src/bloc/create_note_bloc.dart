// import 'package:epoints_task_manager_mobile/common/lang_key.dart';
// import 'package:epoints_task_manager_mobile/common/localization/app_localizations.dart';
// import 'package:epoints_task_manager_mobile/data/models/base/response_model.dart';
// import 'package:epoints_task_manager_mobile/data/models/request/customer_note_store_request_model.dart';
// import 'package:epoints_task_manager_mobile/presentation/interface/base_bloc.dart';
// import 'package:epoints_task_manager_mobile/presentation/utils/custom_navigator.dart';
// import 'package:flutter/material.dart';

// class CreateNoteBloc extends BaseBloc {
//   CreateNoteBloc(BuildContext context) {
//     setContext(context);
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   final FocusNode focusNote = FocusNode();
//   final TextEditingController controllerNote = TextEditingController();

//   customerNoteStore(CustomerNoteStoreRequestModel model) async {
//     CustomNavigator.showProgressDialog(context);
//     ResponseModel response = await repository.customerNoteStore(context, model);
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
