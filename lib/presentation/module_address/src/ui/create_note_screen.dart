// import 'package:epoints_task_manager_mobile/common/lang_key.dart';
// import 'package:epoints_task_manager_mobile/common/localization/app_localizations.dart';
// import 'package:epoints_task_manager_mobile/common/theme.dart';
// import 'package:epoints_task_manager_mobile/data/models/request/customer_note_store_request_model.dart';
// import 'package:epoints_task_manager_mobile/data/models/response/customer_detail_response_model.dart';
// import 'package:epoints_task_manager_mobile/presentation/modules/main_module/modules/home_module/modules/customer_module/modules/customer_create_module/src/bloc/create_note_bloc.dart';
// import 'package:epoints_task_manager_mobile/presentation/utils/custom_navigator.dart';
// import 'package:epoints_task_manager_mobile/presentation/widgets/widget.dart';
// import 'package:flutter/material.dart';

// class CreateNoteScreen extends StatefulWidget {
//   final CustomerDetailResponseModel model;

//   const CreateNoteScreen({super.key, required this.model});

//   @override
//   CreateNoteScreenState createState() => CreateNoteScreenState();
// }

// class CreateNoteScreenState extends State<CreateNoteScreen> {
//   late CreateNoteBloc _bloc;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _bloc = CreateNoteBloc(context);
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _bloc.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomBottomSheet(
//       title: AppLocalizations.text(LangKey.add_note),
//       isBottomSheet: false,
//       body: CustomListView(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         children: [
//           CustomTextField(
//             controller: _bloc.controllerNote,
//             focusNode: _bloc.focusNote,
//             hintText: AppLocalizations.text(LangKey.enter_note),
//             textInputAction: TextInputAction.newline,
//             keyboardType: TextInputType.multiline,
//             backgroundColor: Colors.transparent,
//             borderColor: AppColors.borderColor,
//             maxLines: 3,
//             autofocus: true,
//           ),
//           CustomButton(
//             text: AppLocalizations.text(LangKey.add),
//             onTap: () {
//               if (_bloc.controllerNote.text.trim().isEmpty) {
//                 CustomNavigator.showCustomAlertDialog(
//                     context,
//                     AppLocalizations.text(LangKey.notification),
//                     AppLocalizations.text(LangKey.customer_create_note_error));
//                 return;
//               }
//               _bloc.customerNoteStore(CustomerNoteStoreRequestModel(
//                   customerId: widget.model.customerId,
//                   note: _bloc.controllerNote.text));
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
