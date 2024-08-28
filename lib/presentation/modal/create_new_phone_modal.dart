import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/request/add_tag_model_request.dart';
import 'package:lead_plugin_epoint/model/response/description_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/bloc/create_potential_customer_bloc.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';

class CreateNewPhoneModal extends StatefulWidget {
  final CreatePotentialCustomerBloc bloc;
  CreateNewPhoneModal({Key? key, required this.bloc}) : super(key: key);

  @override
  _CreateNewPhoneModalState createState() => _CreateNewPhoneModalState();
}

class _CreateNewPhoneModalState extends State<CreateNewPhoneModal>
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
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
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
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      height: _isKeyboardVisible
          ? MediaQuery.of(context).size.height * 0.55
          : MediaQuery.of(context).size.height * 0.28,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(15.0),
              child: Center(
                child: Text(
                  "Thêm số điện thoại",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              )),
          textfield("Nhập số điện thoại", "", Assets.iconCall,
              fillText: _nameText, focusNode: _nameFocusNode),
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
        if (_nameText.text.isNotEmpty) {
          print(_nameText.text);
          if ((!Validators().isValidPhone(_nameText.text.trim())) &&
              (!Validators().isNumber(_nameText.text.trim()))) {
            LeadConnection.showMyDialog(context,
                AppLocalizations.text(LangKey.phoneNumberNotCorrectFormat),
                warning: true);
            return;
          } else {
            widget.bloc.listPhone.add(_nameText.text.trim());
            Navigator.of(context).pop(true);
          }
        }
      },
      child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              // AppLocalizations.text(LangKey.convertCustomers),
              "THÊM SỐ ĐIỆN THOẠI",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
          )),
    );
  }

  Widget textfield(String? title, String content, String icon,
      {GestureTapCallback? ontap,
      TextEditingController? fillText,
      FocusNode? focusNode,
      TextInputType? inputType}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: (ontap != null) ? ontap : null,
        child: TextField(
          textInputAction: TextInputAction.done,
          enabled: true,
          maxLength: 10,
          controller: fillText,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            counterText: "",
            isCollapsed: true,
            contentPadding: EdgeInsets.all(12.0),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: Color.fromARGB(255, 86, 252, 171)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xFFB8BFC9)),
            ),
            label: (content == "")
                ? RichText(
                    text: TextSpan(
                    text: title,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: const Color(0xFF858080),
                        fontWeight: FontWeight.normal),
                  ))
                : Text(
                    content,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
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
            isDense: true,
          ),
          onChanged: (event) {},
        ),
      ),
    );
  }
}
