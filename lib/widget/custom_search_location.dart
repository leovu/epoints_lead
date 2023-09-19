import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_textfield_lead.dart';

class CustomSearchLocation extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? hint;
  final TextInputType? inputType;
  final String? suffixIcon;
  final GestureTapCallback? ontapSuffix;
  final TextSelectionControls? selectionControls;
  final List<TextInputFormatter>? inputFormatters;
   CustomSearchLocation(this.focusNode, this.controller, this.onChanged,
      {this.hint, this.inputType, this.inputFormatters, this.onSubmitted, this.selectionControls, this.suffixIcon, this.ontapSuffix});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSizes.minPadding!),
      child: CustomTextField(
        keyboardType: inputType != null ? inputType : TextInputType.text,
        prefixIcon: Assets.iconSearch,
        prefixIconColor: AppColors.dark,selectionControls: selectionControls,
        hintText:
            hint != null ? hint : AppLocalizations.text(LangKey.enter_keyword),
        controller: controller,
        focusNode: focusNode,
        radius: 8.0,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        suffixIcon: suffixIcon,
        suffixIconColor: Color(0xFF727682),
        onSuffixIconTap: ontapSuffix,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
