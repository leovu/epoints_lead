import 'dart:io';

import 'package:auto_size_text_plus/auto_size_text_plus.dart';
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/http_connection.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/bloc/detail_potential_customer_bloc.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_scaffold.dart';

import '../../../../common/lang_key.dart';
import '../../../../common/localization/app_localizations.dart';

class AddFileScreen extends StatefulWidget {
  final DetailPotentialCustomerBloc bloc;

  const AddFileScreen({super.key, required this.bloc});

  @override
  State<AddFileScreen> createState() => _AddFileScreenState();
}

class _AddFileScreenState extends State<AddFileScreen>
    with WidgetsBindingObserver {
  TextEditingController noteController = TextEditingController();
  FocusNode noteFocusNode = FocusNode();
  File? file;
  var _isKeyboardVisible = false;

  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
    super.didChangeMetrics();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool validateAllow() {
    if (file == null) {
      LeadConnection.showMyDialog(
          context, AppLocalizations.text(LangKey.pleaseUploadFile),
          warning: true);
      return false;
    }
    return true;
  }

  _buildBody() {
    return Padding(
      padding: EdgeInsets.all(AppSizes.minPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            "File",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          ),
          SizedBox(height: 10),
          (file != null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: _buildFile(file),
                    ),
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          widget.bloc.uploadFile().then((value) {
                            setState(() {
                              if (value != null) {
                                file = value;
                              }
                            });
                          });
                        },
                        child: Text(
                          AppLocalizations.text(LangKey.change)!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                  ],
                )
              : CustomButton(
                  backgroundColor: AppColors.white,
                  borderColor: AppColors.primaryColor,
                  ontap: () {
                    widget.bloc.uploadFile().then((value) {
                      setState(() {
                        file = value;
                      });
                    });
                  },
                  text: AppLocalizations.text(LangKey.chooseFile),
                  style: AppTextStyles.style14PrimaryBold,
                ),
          SizedBox(height: 10),
          _buildNote(),
          Spacer(),
          Visibility(visible: !_isKeyboardVisible, child: _buildButton()),
          Container(
            height: 20.0,
          )
        ],
      ),
    );
  }

  _buildFile(File? file) {
    return (file != null)
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      pathToImage(file.path)!,
                      width: 24,
                    ),
                    Container(
                      width: 5.0,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.5),
                      child: AutoSizeText(
                        file.path.split('/').last,
                        style: AppTextStyles.style14BlackNormal,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  _buildNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.text(LangKey.attachmentContent)!,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.primaryColor),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: noteController,
          focusNode: noteFocusNode,
          textInputAction: TextInputAction.done,
          maxLength: 500,
          decoration: InputDecoration(
            counterText: "",
            hintText: AppLocalizations.text(LangKey.thisIsAttachmentContent),
            hintStyle: AppTextStyles.style13GrayWeight400,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey700Color, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey700Color, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          maxLines: 4,
          minLines: 4,
          onSubmitted: (value) {
            noteFocusNode.unfocus();
          },
        ),
      ],
    );
  }

  Widget _buildButton() {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () async {
          if (validateAllow()) {
            widget.bloc
                .uploadFileAWS(MultipartFileModel(file: file),
                    content: noteController.text)
                .then((value) {
              if (value) {
                widget.bloc.getListFile(context);
                Navigator.pop(context);
              }
            });
          }
        },
        child: Center(
          child: Text(
            AppLocalizations.text(LangKey.save)!,
            style: AppTextStyles.style14WhiteWeight600,
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: AppLocalizations.text(LangKey.uploadFile),
      body: _buildBody(),
    );
  }
}
