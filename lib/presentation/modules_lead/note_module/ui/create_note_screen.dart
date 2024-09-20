
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/note_file_req_res_model.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/note_module/bloc/create_note_bloc.dart';
import 'package:lead_plugin_epoint/widget/custom_bottom_sheet.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:lead_plugin_epoint/widget/custom_textfield.dart';

class CreateNoteScreen extends StatefulWidget {
  final DetailPotentialData model;

  const CreateNoteScreen({super.key, required this.model});

  @override
  CreateNoteScreenState createState() => CreateNoteScreenState();
}

class CreateNoteScreenState extends State<CreateNoteScreen> {
  late CreateNoteBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = CreateNoteBloc(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: AppLocalizations.text(LangKey.add_note),
      isBottomSheet: false,
      body: CustomListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          CustomTextField(
            controller: _bloc.controllerNote,
            focusNode: _bloc.focusNote,
            hintText: AppLocalizations.text(LangKey.enter_note),
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            backgroundColor: Colors.transparent,
            borderColor: AppColors.borderColor,
            maxLines: 3,
            autofocus: true,
          ),
          CustomButton(
            text: AppLocalizations.text(LangKey.add),
            ontap: () {
              if (_bloc.controllerNote.text.trim().isEmpty) {
                CustomNavigator.showCustomAlertDialog(
                    context,
                    AppLocalizations.text(LangKey.notification),
                    AppLocalizations.text(LangKey.customer_create_note_error));
                return;
              }
              _bloc.customerNoteStore(CreateNoteReqModel(
                  customer_lead_id: widget.model.customerLeadId,
                  content: _bloc.controllerNote.text));
            },
          )
        ],
      ),
    );
  }
}