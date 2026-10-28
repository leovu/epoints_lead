import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';

class CreateNewBusinessModal extends StatefulWidget {
  CreateNewBusinessModal({Key? key}) : super(key: key);

  @override
  _CreateNewBusinessModalState createState() => _CreateNewBusinessModalState();
}

class _CreateNewBusinessModalState extends State<CreateNewBusinessModal>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;
  var isExpand = false;
  TextEditingController _nameBusinessText = TextEditingController();
  FocusNode _nameBusinessFocusNode = FocusNode();

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
                  AppLocalizations.text(LangKey.createNewBusiness)!,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.textTitleColor,
                      fontWeight: FontWeight.w600),
                ),
              )),
          _tftCreateNewBusiness(
              AppLocalizations.text(LangKey.enterBusiness_Name),
              "",
              Assets.iconProvince,
              false,
              false,
              true,
              fillText: _nameBusinessText,
              focusNode: _nameBusinessFocusNode),
          SizedBox(
            height: 23.0,
          ),
          Visibility(visible: !_isKeyboardVisible, child: _buildButton()),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        decoration: AppGlass.primaryButton(),
        child: Center(
          child: Text(
            // AppLocalizations.text(LangKey.convertCustomers),
            AppLocalizations.text(LangKey.addNewBusiness)!,
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ));
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
            print(event.toLowerCase());
            if (fillText != null) {
              print(fillText.text);
            }
          },
        ),
      ),
    );
  }
}
