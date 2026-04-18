import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/customer_type.dart';

class CreatePotentialFieldRow extends StatelessWidget {
  final String? title;
  final String? content;
  final String icon;
  final bool mandatory;
  final bool dropdown;
  final bool textfield;
  final GestureTapCallback? ontap;
  final TextEditingController? fillText;
  final FocusNode? focusNode;
  final TextInputType? inputType;
  final ValueChanged<String>? onChanged;

  const CreatePotentialFieldRow({
    Key? key,
    required this.title,
    required this.content,
    required this.icon,
    required this.mandatory,
    required this.dropdown,
    required this.textfield,
    this.ontap,
    this.fillText,
    this.focusNode,
    this.inputType,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InputBorder border = 
    // textfield
    //     ? InputBorder.none
    //     : 
        OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xFFB8BFC9)),
            borderRadius: BorderRadius.circular(10.0),
          );
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: ontap,
        child: TextField(
          enabled: textfield,
          readOnly: !textfield,
          controller: fillText,
          focusNode: focusNode,
          keyboardType: inputType ?? TextInputType.text,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.all(12.0),
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            disabledBorder: border,
            label: (content == null || content == "")
                ? RichText(
                    text: TextSpan(
                        text: title,
                        style: TextStyle(
                            fontSize: AppTextSizes.size15,
                            color: const Color(0xFF858080),
                            fontWeight: FontWeight.normal),
                        children: [
                          if (mandatory)
                            TextSpan(
                                text: "*",
                                style: TextStyle(color: Colors.red))
                        ]))
                : Text(
                    content!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset(
                icon,
                color: AppColors.primaryColor,
              ),
            ),
            prefixIconConstraints:
                BoxConstraints(maxHeight: 32.0, maxWidth: 32.0),
            suffixIcon: dropdown
                ? Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset(Assets.iconDropDown),
                  )
                : null,
            suffixIconConstraints:
                BoxConstraints(maxHeight: 32.0, maxWidth: 32.0),
            isDense: true,
          ),
          onChanged: (value) => onChanged?.call(value),
        ),
      ),
    );
  }
}

class CustomerTypeSelector extends StatelessWidget {
  final List<CustomerTypeModel> customerTypeData;
  final bool selectedPersonal;
  final ValueChanged<bool> onChanged;

  const CustomerTypeSelector({
    Key? key,
    required this.customerTypeData,
    required this.selectedPersonal,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _typeButton(
          context,
          label: AppLocalizations.text(LangKey.personal)!,
          selected: selectedPersonal,
          onTap: () => onChanged(true),
        ),
        _typeButton(
          context,
          label: AppLocalizations.text(LangKey.business)!,
          selected: !selectedPersonal,
          onTap: () => onChanged(false),
        ),
      ],
    );
  }

  Widget _typeButton(BuildContext context,
      {required String label,
      required bool selected,
      required GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 42.0,
        width: MediaQuery.of(context).size.width / 2 - 19,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: selected ? AppColors.primaryColor : Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Colors.black.withValues(alpha: 0.3),
              )
            ]),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                color: selected ? Colors.white : Color(0xFF8E8E8E),
                fontSize: 14.0,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}

class PhoneListItem extends StatelessWidget {
  final String phone;
  final VoidCallback onDelete;
  const PhoneListItem({Key? key, required this.phone, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey200, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset(Assets.iconCall, width: 16),
              ),
              Text(phone, style: AppTextStyles.style14BlackWeight500),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                padding: EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey),
                  onPressed: onDelete,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}

class AddMoreInfoButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddMoreInfoButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                width: 1.0,
                color: Colors.blue,
                style: BorderStyle.solid)),
        child: Center(
          child: Text(
            "+ ${AppLocalizations.text(LangKey.moreInformation)}",
            style: TextStyle(
                fontSize: AppTextSizes.size16,
                color: const Color(0xFF0067AC),
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: AppTextSizes.size16,
            color: const Color(0xFF0067AC),
            fontWeight: FontWeight.normal),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const SubmitButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class AddPhoneButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddPhoneButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text("+ Thêm số điện thoại",
              style: AppTextStyles.style14BlueWeight500),
        ),
      ),
    );
  }
}
