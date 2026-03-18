// import 'package:epoints_task_manager_mobile/common/assets.dart';
// import 'package:epoints_task_manager_mobile/common/constant.dart';
// import 'package:epoints_task_manager_mobile/common/lang_key.dart';
// import 'package:epoints_task_manager_mobile/common/localization/app_localizations.dart';
// import 'package:epoints_task_manager_mobile/common/theme.dart';
// import 'package:epoints_task_manager_mobile/data/models/response/customer_detail_response_model.dart';
// import 'package:epoints_task_manager_mobile/data/models/response/customer_work_response_model.dart';
// import 'package:epoints_task_manager_mobile/presentation/modules/main_module/modules/home_module/modules/customer_module/modules/customer_create_module/src/bloc/create_care_bloc.dart';
// import 'package:epoints_task_manager_mobile/presentation/utils/ultility.dart';
// import 'package:epoints_task_manager_mobile/presentation/widgets/widget.dart';
// import 'package:flutter/material.dart';

// class CreateCareScreen extends StatefulWidget {
//   final CustomerDetailResponseModel model;

//   const CreateCareScreen({super.key, required this.model});

//   @override
//   CreateCareScreenState createState() => CreateCareScreenState();
// }

// class CreateCareScreenState extends State<CreateCareScreen> {
//   late CreateCareBloc _bloc;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _bloc = CreateCareBloc(context);
//     _bloc.model = widget.model;

//     _bloc.controllerTitle.text =
//         "[${AppLocalizations.text(LangKey.calendar)}] ${AppLocalizations.text(LangKey.calendar)} ${widget.model.customerType == customerTypePersonal ? AppLocalizations.text(LangKey.customer) : AppLocalizations.text(LangKey.enterprise)} - [${widget.model.customerCode ?? ""}] ${widget.model.fullName ?? ""}";

//     WidgetsBinding.instance
//         .addPostFrameCallback((_) => _bloc.onRefresh(isRefresh: false));
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _bloc.dispose();
//     super.dispose();
//   }

//   Widget _buildType() {
//     return CustomColumnInformation(
//       title: AppLocalizations.text(LangKey.method_of_care),
//       isRequired: true,
//       child: StreamBuilder(
//           stream: _bloc.outputTypeModels,
//           initialData: _bloc.typeModels,
//           builder: (_, snapshot) {
//             List<CustomDropdownModel>? menus =
//                 snapshot.data as List<CustomDropdownModel>?;
//             return StreamBuilder(
//                 stream: _bloc.outputTypeModel,
//                 initialData: _bloc.typeModel,
//                 builder: (_, snapshot) {
//                   _bloc.typeModel = snapshot.data as CustomDropdownModel?;
//                   return CustomDropdown(
//                     value: _bloc.typeModel,
//                     menus: menus,
//                     hint: AppLocalizations.text(LangKey.method_of_care),
//                     onChanged: (event) => _bloc.setTypeModel(event!),
//                   );
//                 });
//           }),
//     );
//   }

//   Widget _buildTitle() {
//     return CustomColumnInformation(
//       title: AppLocalizations.text(LangKey.title),
//       isRequired: true,
//       child: CustomTextField(
//         focusNode: _bloc.focusTitle,
//         controller: _bloc.controllerTitle,
//         backgroundColor: Colors.transparent,
//         borderColor: AppColors.borderColor,
//       ),
//     );
//   }

//   Widget _buildResult() {
//     return CustomColumnInformation(
//       title: AppLocalizations.text(LangKey.care_outcomes),
//       isRequired: true,
//       child: StreamBuilder(
//           stream: _bloc.outputResultModels,
//           initialData: _bloc.resultModels,
//           builder: (_, snapshot) {
//             List<CustomDropdownModel>? menus =
//                 snapshot.data as List<CustomDropdownModel>?;
//             return StreamBuilder(
//                 stream: _bloc.outputResultModel,
//                 initialData: _bloc.resultModel,
//                 builder: (_, snapshot) {
//                   _bloc.resultModel = snapshot.data as CustomDropdownModel?;
//                   return CustomDropdown(
//                     value: _bloc.resultModel,
//                     menus: menus,
//                     hint: AppLocalizations.text(LangKey.care_outcomes),
//                     onChanged: (event) => _bloc.setResultModel(event!),
//                   );
//                 });
//           }),
//     );
//   }

//   Widget _buildNote() {
//     return CustomColumnInformation(
//       title: AppLocalizations.text(LangKey.care_content),
//       child: CustomTextField(
//         focusNode: _bloc.focusNote,
//         controller: _bloc.controllerNote,
//         backgroundColor: Colors.transparent,
//         borderColor: AppColors.borderColor,
//         maxLines: 3,
//         keyboardType: TextInputType.multiline,
//         textInputAction: TextInputAction.newline,
//         hintText: "${AppLocalizations.text(LangKey.enter)} ${AppLocalizations.text(LangKey.care_content)!.toLowerCase()}",
//       ),
//     );
//   }

//   Widget _buildFile() {
//     return CustomColumnInformation(
//       title: AppLocalizations.text(LangKey.document),
//       titleSuffix: Text(
//         "+ ${AppLocalizations.text(LangKey.upload_file)}",
//         style: AppTextStyles.style14PrimaryRegular,
//         textAlign: TextAlign.right,
//       ),
//       onTitleTap: _bloc.onUploadFile,
//       child: Column(
//         children: [
//           StreamBuilder(
//               stream: _bloc.outputFiles,
//               initialData: _bloc.files,
//               builder: (_, snapshot) {
//                 List<CustomerWorkDocumentModel> models =
//                     snapshot.data as List<CustomerWorkDocumentModel>;
//                 if (models.isEmpty) {
//                   return Text(
//                     AppLocalizations.text(LangKey.file_empty)!,
//                     style: AppTextStyles.style12HintNormalItalic,
//                   );
//                 }
//                 return CustomListView(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   padding: EdgeInsets.zero,
//                   children: models.map((e) {
//                     String path = (e.path ?? "").split(".").last;

//                     String? image = pathToImage(path);
//                     bool isImage = false;

//                     if (image == null) {
//                       image = e.path;
//                       isImage = true;
//                     }

//                     return InkWell(
//                       child: Row(
//                         children: [
//                           isImage
//                               ? CustomNetworkImage(
//                                   width: AppSizes.sizeOnTap,
//                                   height: AppSizes.sizeOnTap,
//                                   url: image,
//                                 )
//                               : Image.asset(
//                                   image!,
//                                   width: AppSizes.sizeOnTap,
//                                 ),
//                           Container(
//                             width: AppSizes.minPadding,
//                           ),
//                           Expanded(
//                               child: Text(
//                             e.fileName ?? "",
//                             style: AppTextStyles.style13BlackNormal,
//                           )),
//                           Container(
//                             width: AppSizes.minPadding,
//                           ),
//                           InkWell(
//                             child: CustomImageIcon(
//                               icon: Assets.iconTrash,
//                               size: 20.0,
//                               color: AppColors.darkRedColor,
//                             ),
//                             onTap: () => _bloc.onRemoveFile(e),
//                           )
//                         ],
//                       ),
//                       onTap: () => openFile(context, e.fileName, e.path),
//                     );
//                   }).toList(),
//                 );
//               }),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppointmentDate() {
//     return StreamBuilder(
//         stream: _bloc.outputDate,
//         initialData: _bloc.date,
//         builder: (_, snapshot) {
//           _bloc.date = snapshot.data as DateTime;
//           return CustomColumnInformation(
//             title: AppLocalizations.text(LangKey.appointment_time),
//             titleIcon: Assets.iconCalendarFill,
//             isRequired: true,
//             content: formatDate(_bloc.date, format: AppFormat.formatDateTime),
//             backgroundColor: Colors.transparent,
//             borderColor: AppColors.borderColor,
//             hintText:
//                 "${AppLocalizations.text(LangKey.select)} ${AppLocalizations.text(LangKey.appointment_time)!.toLowerCase()}",
//             suffixIcon: Assets.iconCalendar1,
//             onTap: _bloc.onShowDate,
//           );
//         });
//   }

//   Widget _buildAppointmentTime() {
//     return CustomColumnInformation(
//       title: AppLocalizations.text(LangKey.previous_time_reminder),
//       child: StreamBuilder(
//           stream: _bloc.outputTimeModels,
//           initialData: _bloc.timeModels,
//           builder: (_, snapshot) {
//             return Wrap(
//               spacing: AppSizes.minPadding,
//               runSpacing: AppSizes.minPadding,
//               children: _bloc.timeModels
//                   .map((e) => CustomChipSelected(
//                         text: e.text,
//                         type: true,
//                         selected: e.selected,
//                         onTap: () => _bloc.onTime(e),
//                       ))
//                   .toList(),
//             );
//           }),
//     );
//   }

//   Widget _buildAppointmentNote() {
//     return CustomColumnInformation(
//       title: AppLocalizations.text(LangKey.content),
//       isRequired: true,
//       child: CustomTextField(
//         focusNode: _bloc.focusAppointmentNote,
//         controller: _bloc.controllerAppointmentNote,
//         backgroundColor: Colors.transparent,
//         borderColor: AppColors.borderColor,
//         maxLines: 3,
//         keyboardType: TextInputType.multiline,
//         textInputAction: TextInputAction.newline,
//         hintText: AppLocalizations.text(LangKey.enter_content),
//       ),
//     );
//   }

//   Widget _buildAppointmentContent() {
//     return CustomListView(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.only(top: AppSizes.minPadding),
//       children: [
//         _buildAppointmentDate(),
//         _buildAppointmentTime(),
//         _buildAppointmentNote(),
//       ],
//     );
//   }

//   Widget _buildStaffAppointment() {
//     return StreamBuilder(
//         stream: _bloc.outputStaffAppointment,
//         initialData: _bloc.staffAppointment,
//         builder: (_, snapshot) {
//           return Column(
//             children: [
//               Row(
//                 children: [
//                   CustomCheckbox(
//                       _bloc.staffAppointment, _bloc.onStaffAppointment),
//                   Expanded(
//                       child: Text(
//                     AppLocalizations.text(LangKey.employee_appointment)!,
//                     style: AppTextStyles.style14BlackNormal,
//                   ))
//                 ],
//               ),
//               if (_bloc.staffAppointment) _buildAppointmentContent()
//             ],
//           );
//         });
//   }

//   Widget _buildContent() {
//     return CustomListView(
//       children: [
//         _buildType(),
//         _buildTitle(),
//         _buildResult(),
//         _buildNote(),
//         _buildFile(),
//         _buildStaffAppointment(),
//       ],
//       onRefresh: _bloc.onRefresh,
//     );
//   }

//   Widget _buildBottom() {
//     return CustomBottom(
//       text: AppLocalizations.text(LangKey.save),
//       onTap: _bloc.onSave,
//       subText: AppLocalizations.text(LangKey.exit),
//       onSubTap: _bloc.onExit,
//     );
//   }

//   Widget _buildBody() {
//     return Column(
//       children: [Expanded(child: _buildContent()), _buildBottom()],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       title: AppLocalizations.text(LangKey.create_customer_care),
//       body: _buildBody(),
//     );
//   }
// }
