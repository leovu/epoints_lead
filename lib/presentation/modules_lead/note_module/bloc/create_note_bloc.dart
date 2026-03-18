import 'package:flutter/cupertino.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/note_file_req_res_model.dart';
import 'package:lead_plugin_epoint/model/response_model.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';

class CreateNoteBloc extends BaseBloc {
  CreateNoteBloc(BuildContext context) {
    setContext(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  final FocusNode focusNote = FocusNode();
  final TextEditingController controllerNote = TextEditingController();

  customerNoteStore(CreateNoteReqModel model) async {
    CustomNavigator.showProgressDialog(context);
    ResponseModel response = await repository.addNote(context, model);
    CustomNavigator.hideProgressDialog();
    if (response.success!) {
      await CustomNavigator.showCustomAlertDialog(
          context!,
          AppLocalizations.text(LangKey.notification),
          response.errorDescription ?? "");
      CustomNavigator.pop(context!, object: true);
    }
  }
}
