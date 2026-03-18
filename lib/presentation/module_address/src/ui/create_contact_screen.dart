// import 'package:epoints_task_manager_mobile/common/assets.dart';
// import 'package:epoints_task_manager_mobile/common/constant.dart';
// import 'package:epoints_task_manager_mobile/common/lang_key.dart';
// import 'package:epoints_task_manager_mobile/common/localization/app_localizations.dart';
// import 'package:epoints_task_manager_mobile/common/theme.dart';
// import 'package:epoints_task_manager_mobile/data/models/base/customer_create_contact_model.dart';
// import 'package:epoints_task_manager_mobile/presentation/modules/main_module/modules/home_module/modules/customer_module/modules/customer_create_module/src/bloc/create_contact_bloc.dart';
// import 'package:epoints_task_manager_mobile/presentation/utils/ultility.dart';
// import 'package:epoints_task_manager_mobile/presentation/widgets/widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class CreateContactScreen extends StatefulWidget {
//   final CustomerCreateContactModel? model;

//   const CreateContactScreen({super.key, this.model});

//   @override
//   CreateContactScreenState createState() => CreateContactScreenState();
// }

// class CreateContactScreenState extends State<CreateContactScreen> {
//   late CreateContactBloc _bloc;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _bloc = CreateContactBloc(context);

//     if(widget.model != null){
//       _bloc.controllerName.text = widget.model!.name ?? "";
//       _bloc.controllerPhone.text = widget.model!.phone ?? "";
//       _bloc.controllerEmail.text = widget.model!.email ?? "";
//       _bloc.positionModel = widget.model!.positionModel;
//     }

//     WidgetsBinding.instance.addPostFrameCallback((_) => _bloc.onRefresh(isRefresh: false));
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _bloc.dispose();
//     super.dispose();
//   }

//   Widget _buildName() {
//     return CustomColumnInformation(
//       title: AppLocalizations.text(LangKey.full_name),
//       isRequired: true,
//       titleIcon: Assets.iconUser,
//       child: CustomTextField(
//         focusNode: _bloc.focusName,
//         controller: _bloc.controllerName,
//         backgroundColor: Colors.transparent,
//         borderColor: AppColors.borderColor,
//         hintText:
//         "${AppLocalizations.text(LangKey.enter1)} ${AppLocalizations.text(LangKey.full_name)!.toLowerCase()}",
//         onSubmitted: (_) => fieldFocusChange(context, _bloc.focusName, _bloc.focusPhone),
//       ),
//     );
//   }

//   Widget _buildPhone() {
//     return CustomColumnInformation(
//       title: AppLocalizations.text(LangKey.phone_number),
//       isRequired: true,
//       titleIcon: Assets.iconPhone,
//       child: CustomTextField(
//         focusNode: _bloc.focusPhone,
//         controller: _bloc.controllerPhone,
//         backgroundColor: Colors.transparent,
//         borderColor: AppColors.borderColor,
//         keyboardType: TextInputType.phone,
//         hintText:
//         "${AppLocalizations.text(LangKey.enter1)} ${AppLocalizations.text(LangKey.phone_number)!.toLowerCase()}",
//         inputFormatters: [
//           FilteringTextInputFormatter.digitsOnly,
//           LengthLimitingTextInputFormatter(maxLengthPhone)
//         ],
//         onSubmitted: (_) => fieldFocusChange(context, _bloc.focusPhone, _bloc.focusEmail),
//       ),
//     );
//   }

//   Widget _buildEmail() {
//     return CustomColumnInformation(
//       title: AppLocalizations.text(LangKey.email),
//       titleIcon: Assets.iconMail,
//       child: CustomTextField(
//         focusNode: _bloc.focusEmail,
//         controller: _bloc.controllerEmail,
//         backgroundColor: Colors.transparent,
//         borderColor: AppColors.borderColor,
//         hintText:
//         "${AppLocalizations.text(LangKey.enter1)} ${AppLocalizations.text(LangKey.email)!.toLowerCase()}",
//         keyboardType: TextInputType.emailAddress,
//       ),
//     );
//   }

//   Widget _buildPosition() {
//     return CustomColumnInformation(
//         title: AppLocalizations.text(LangKey.position),
//         titleIcon: Assets.iconUserStand,
//         child: StreamBuilder(
//             stream: _bloc.outputPositionModels,
//             initialData: _bloc.positionModels,
//             builder: (_, snapshot) {
//               List<CustomDropdownModel>? menus =
//               snapshot.data as List<CustomDropdownModel>?;
//               return StreamBuilder(
//                   stream: _bloc.outputPositionModel,
//                   initialData: _bloc.positionModel,
//                   builder: (_, snapshot) {
//                     _bloc.positionModel = snapshot.data as CustomDropdownModel?;
//                     return CustomDropdown(
//                       value: _bloc.positionModel,
//                       menus: menus,
//                       hint: "${AppLocalizations.text(LangKey.select)} ${AppLocalizations.text(LangKey.position)!.toLowerCase()}",
//                       onChanged: (event) => _bloc.setPositionModel(event!),
//                       onRemove: () => _bloc.setPositionModel(null),
//                     );
//                   });
//             }));
//   }

//   Widget _buildContent(){
//     return CustomListView(
//       children: [
//         _buildName(),
//         _buildPhone(),
//         _buildEmail(),
//         _buildPosition(),
//       ],
//       onRefresh: _bloc.onRefresh,
//     );
//   }

//   Widget _buildBottom(){
//     return CustomBottom(
//       text: AppLocalizations.text(LangKey.confirm,),
//       onTap: _bloc.onConfirm,
//     );
//   }

//   Widget _buildBody(){
//     return Column(
//       children: [
//         Expanded(child: _buildContent()),
//         _buildBottom()
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       title: AppLocalizations.text(LangKey.enter_contact_person),
//       body: _buildBody(),
//     );
//   }
// }
