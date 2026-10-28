import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/request/add_tag_model_request.dart';
import 'package:lead_plugin_epoint/model/response/description_model_response.dart';

class CreateNewTagModal extends StatefulWidget {
  CreateNewTagModal({Key? key}) : super(key: key);

  @override
  _CreateNewTagModalState createState() => _CreateNewTagModalState();
}

class _CreateNewTagModalState extends State<CreateNewTagModal>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;
  var isExpand = false;
  TextEditingController _nameText = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 50, top: 10, left: 13.0, right: 13.0),
      decoration: AppGlass.sheet(),
      height: _isKeyboardVisible
          ? MediaQuery.of(context).size.height * 0.55
          : MediaQuery.of(context).size.height * 0.28,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(15.0),
              child: Center(
                child: Text(
                  AppLocalizations.text(LangKey.addTag)!,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.textTitleColor,
                      fontWeight: FontWeight.w600),
                ),
              )),
          _tftCreateNewBusiness(
              AppLocalizations.text(LangKey.enterNewTag),
              "",
              Assets.iconTag,
              false,
              false,
              true,
              fillText: _nameText,
              focusNode: _nameFocusNode),
          SizedBox(
            height: 23.0,
          ),
          Visibility(visible: !_isKeyboardVisible, child: _buildButton()),
        ],
      ),
    );
  }

   Widget _buildButton() {
    return InkWell(
      onTap: () async {
        if (_nameText.text != "") {
          LeadConnection.showLoading(context);
          DescriptionModelResponse? result =
              await LeadConnection.addTag(
                  context, AddTagModelRequest(
                    name: _nameText.text,
                  ));
                  Navigator.of(context).pop();

          if (result != null) {
            if (result.errorCode == 0) {
              await LeadConnection.showMyDialog(context, result.errorDescription);
              await Future.delayed(Duration(seconds: 2));

              Navigator.of(context).pop(true);
            } else {
              LeadConnection.showMyDialog(context, result.errorDescription);
            }
          }
        } else {
          LeadConnection.showMyDialog(context, "Vui lòng nhập tên nhãn");
        }
      },
      child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          decoration: AppGlass.primaryButton(),
          child: Center(
            child: Text(
              // AppLocalizations.text(LangKey.convertCustomers),
              AppLocalizations.text(LangKey.addNewTag)!,
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
          )),
    );
  }
  Widget _tftCreateNewBusiness(String? title, String content, String icon,
      bool mandatory, bool dropdown, bool textfield,
      {GestureTapCallback? ontap,
      TextEditingController? fillText,
      FocusNode? focusNode,
      TextInputType? inputType}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: (ontap != null) ? ontap : null,
        child: TextField(
          enabled: textfield,
          readOnly: !textfield,
          controller: fillText,
          focusNode: focusNode,
          keyboardType: (inputType != null) ? inputType : TextInputType.text,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.all(12.0),
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: AppColors.secondaryColorMix),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            label: (content == "")
                ? RichText(
                    text: TextSpan(
                        text: title,
                        style: TextStyle(
                            fontSize: 15.0,
                            color: AppColors.textSecondaryColor,
                            fontWeight: FontWeight.normal),
                        children: [
                        if (mandatory)
                          TextSpan(
                              text: "*",
                              style: TextStyle(color: AppColors.dangerColor))
                      ]))
                : Text(
                    content,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: AppColors.textTitleColor,
                        fontWeight: FontWeight.normal),
                  ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset(
                icon,
              ),
            ),
            prefixIconConstraints:
                BoxConstraints(maxHeight: 32.0, maxWidth: 32.0),
            suffixIcon: dropdown
                ? Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset(
                      Assets.iconDropDown,
                    ),
                  )
                : Container(),
            suffixIconConstraints:
                BoxConstraints(maxHeight: 32.0, maxWidth: 32.0),
            isDense: true,
          ),
          onChanged: (event) {
          },
        ),
      ),
    );
  }
}
