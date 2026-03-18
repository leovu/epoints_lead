import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_textfield.dart';

class CustomSearchBox extends StatelessWidget {

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final GestureTapCallback? onSearch;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? padding;
  final String? suffixIcon;
  final GestureTapCallback? onSuffixTap;

  const CustomSearchBox({
    Key? key,
    this.controller,
    this.focusNode,
    this.hint,
    this.onSearch,
    this.onChanged,
    this.padding, this.suffixIcon, this.onSuffixTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:padding ?? EdgeInsets.only(
        top: AppSizes.maxPadding,
        right: AppSizes.maxPadding,
        left: AppSizes.maxPadding),
      child: CustomTextField(
        focusNode: focusNode,
        controller: controller,
        hintText: hint ?? AppLocalizations.text(LangKey.enter_search_information),
        backgroundColor: Colors.transparent,
        borderColor: AppColors.borderColor,
        suffixIcon: suffixIcon ?? Assets.iconSearch,
        onSuffixTap: onSuffixTap ?? onSearch,
        textInputAction: TextInputAction.search,
        onSubmitted: onSearch == null ? null : (_) => onSearch!(),
        onChanged: onChanged,
      ),
    );
  }
}
