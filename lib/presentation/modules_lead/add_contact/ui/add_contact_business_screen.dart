import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/request/add_contact_req_model.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/bloc/detail_potential_customer_bloc.dart';
import 'package:lead_plugin_epoint/widget/custom_scaffold.dart';
import 'package:lead_plugin_epoint/widget/widget.dart';

class AddContactBusinessScreen extends StatefulWidget {
  final DetailPotentialCustomerBloc? bloc;
  const AddContactBusinessScreen({super.key, this.bloc});

  @override
  State<AddContactBusinessScreen> createState() =>
      _AddContactBusinessScreenState();
}

class _AddContactBusinessScreenState extends State<AddContactBusinessScreen>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  TextEditingController _emailContactPersonText = TextEditingController();
  FocusNode _emailContactPersonFocusNode = FocusNode();

  TextEditingController _fullNameText = TextEditingController();
  FocusNode _fullnameFocusNode = FocusNode();

  TextEditingController _phoneNumberText = TextEditingController();
  FocusNode _phoneNumberFocusNode = FocusNode();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.bloc!.positionData?.clear();
    widget.bloc!.positionSelected = null;
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

  bool validateAllow() {
    if (_fullNameText.text.isEmpty || _phoneNumberText.text.isEmpty) {
      LeadConnection.showMyDialog(
          context, AppLocalizations.text(LangKey.warningChooseAllRequiredInfo),
          warning: true);
      return false;
    } else {
      return true;
    }
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(AppSizes.minPadding),
          child: listWidget(),
        )),
        Visibility(visible: !_isKeyboardVisible, child: _buildButton()),
        Container(
          height: 20.0,
        )
      ],
    );
  }

  Widget listWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextfieldDropdownWidget(
          title: AppLocalizations.text(LangKey.fullName),
          content: "",
          mandatory: true,
          textfield: true,
          icon: Assets.iconPerson,
          fillText: _fullNameText,
          focusNode: _fullnameFocusNode,
          inputType: TextInputType.text,
        ),
        CustomTextfieldDropdownWidget(
          title: AppLocalizations.text(LangKey.phoneNumber),
          content: "",
          mandatory: true,
          textfield: true,
          icon: Assets.iconCall,
          fillText: _phoneNumberText,
          focusNode: _phoneNumberFocusNode,
          inputType: TextInputType.phone,
        ),
        CustomTextfieldDropdownWidget(
          title: AppLocalizations.text(LangKey.email),
          content: "",
          textfield: true,
          mandatory: false,
          icon: Assets.iconEmail,
          fillText: _emailContactPersonText,
          focusNode: _emailContactPersonFocusNode,
          inputType: TextInputType.text,
        ),
        CustomTextfieldDropdownWidget(
          title: AppLocalizations.text(LangKey.choose_position),
          content: widget.bloc!.positionSelected?.staffTitleName ?? "",
          dropdown: true,
          textfield: false,
          icon: Assets.iconPosition,
          ontap: () async {
            if (widget.bloc!.positionData == null ||
                widget.bloc!.positionData!.length == 0) {
              LeadConnection.showLoading(context);
              var positions = await LeadConnection.getPosition(context);
              Navigator.of(context).pop();
              if (positions != null) {
                widget.bloc!.positionData = positions.data;

                widget.bloc!.loadPositionModal().then((value) {
                  if (value) {
                    setState(() {});
                  }
                });
              }
            } else {
              widget.bloc!.loadPositionModal().then((value) {
                if (value) {
                  setState(() {});
                }
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildButton() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () async {
          if (validateAllow()) {
            widget.bloc!.addContact(context, AddContactRequest(
                customerLeadCode: widget.bloc!.detail?.customerLeadCode,
                fullName: _fullNameText.text,
                phone: _phoneNumberText.text,
                email: _emailContactPersonText.text,
                position: "${widget.bloc!.positionSelected?.staffTitleId ?? 0}")).then(
                (value) {
              if (value ?? false) {
                widget.bloc!.getContactList(context);
                Navigator.pop(context);
              }
          });
          }
        },
        child: Center(
          child: Text(
            "Thêm người liên hệ",
            style: AppTextStyles.style14WhiteWeight600,
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: CustomScaffold(
        title: "Thêm người liên hệ",
        body: _buildBody(),
      ),
    );
  }
}
