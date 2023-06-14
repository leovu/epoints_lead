import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';
import 'package:lead_plugin_epoint/widget/custom_inkwell.dart';

class CustomTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextSelectionControls? selectionControls;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final String? suffixIcon;
  final Color? suffixIconColor;
  final double? suffixSize;
  final Color? backgroundColor;
  final Function? onSuffixIconTap;
  final String? prefixIcon;
  final Color? prefixIconColor;
  final Function? onPrefixIconTap;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final bool? autofocus;
  final bool readOnly;
  final Function? onTap;
  final bool enableBorder;
  final int? maxLines;
  final int? maxLength;
  final bool isPhone;
  final TextStyle? style;
  final int limitInput;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double verticalMargin;
  final double horizontalMargin;
  final String error;
  final double radius;
  final Widget? suffixChild;
  final TextCapitalization? textCapitalization;

  CustomTextField(
      {this.focusNode,
      this.controller,
      this.hintText,
      this.labelText,
      this.suffixIcon,
      this.suffixIconColor,
      this.onSuffixIconTap,
      this.obscureText = false,
      this.keyboardType,
      this.textInputAction,
      this.onSubmitted,
      this.inputFormatters,
      this.onChanged,
      this.autofocus,
      this.readOnly = false,
      this.onTap,
      this.enableBorder = false,
      this.maxLines,
      this.maxLength,
      this.isPhone = false,
      this.style,
      this.limitInput = 10,
      this.verticalPadding,
      this.horizontalPadding,
      this.horizontalMargin = 0.0,
      this.verticalMargin = 0.0,
      this.error = "",
      this.prefixIcon,
      this.prefixIconColor,
      this.onPrefixIconTap,
      this.radius = 5.0,
      this.backgroundColor,
      this.hintStyle,
      this.suffixSize,
      this.suffixChild,
      this.textCapitalization, this.selectionControls});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: horizontalMargin,
              left: verticalMargin,
              right: verticalMargin),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              color: backgroundColor ??
                  ((error != "")
                      ? AppColors.white
                      : (enableBorder ? AppColors.white : AppColors.lightGrey)),
              border: Border.all(
                  width: 1.0,
                  color: (error != "")
                      ? AppColors.redColor
                      : (enableBorder
                          ? AppColors.primaryColor
                          : AppColors.lightGrey),
                  style: BorderStyle.solid)),
          child: Row(
            children: [
              if (prefixIcon != null)
                CustomInkWell(
                  onTap: onPrefixIconTap ?? onTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding ?? 15,
                    ),
                    child: CustomImageIcon(
                      icon: prefixIcon,
                      size: 20,
                      color: prefixIconColor ?? AppColors.primaryColor,
                    ),
                  ),
                ),
              Expanded(
                child: TextField(
                  focusNode: focusNode ?? FocusNode(),
                  controller: controller ?? TextEditingController(),
                  selectionControls: selectionControls,
                  keyboardType: isPhone
                      ? TextInputType.phone
                      : (obscureText
                          ? TextInputType.visiblePassword
                          : (keyboardType ?? TextInputType.emailAddress)),
                  textInputAction: textInputAction ?? TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: (prefixIcon == null)
                        ? EdgeInsets.only(
                            left: horizontalPadding ?? 15,
                            top: verticalPadding ?? 15,
                            bottom: verticalPadding ?? 15)
                        : EdgeInsets.symmetric(
                            vertical: verticalPadding ?? 15,
                          ),
                    hintText: hintText,
                    hintStyle: hintStyle ?? AppTextStyles.style15Grey600Normal,
                    labelText: labelText,
                    labelStyle: hintStyle ?? AppTextStyles.style15Grey600Normal,
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  style: style ?? AppTextStyles.style15BlackNormal,
                  obscureText: obscureText,
                  onSubmitted: onSubmitted,
                  inputFormatters: isPhone
                      ? [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(limitInput),
                        ]
                      : inputFormatters,
                  onChanged: onChanged,
                  autofocus: autofocus ?? false,
                  maxLines: maxLines ?? 1,
                  maxLength: maxLength,
                  readOnly: readOnly,
                  onTap: onTap as void Function()?,
                  textCapitalization:
                      textCapitalization ?? TextCapitalization.none,
                ),
              ),
              if (suffixIcon != null || suffixChild != null)
                suffixChild ??
                    CustomInkWell(
                      onTap: onSuffixIconTap ?? onTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding ?? 20,
                        ),
                        child: CustomImageIcon(
                          icon: suffixIcon,
                          size: suffixSize ?? 20,
                          color: suffixIconColor ?? AppColors.primaryColor,
                        ),
                      ),
                    )
            ],
          ),
        ),
        if (error != "")
          error != "."
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                      bottom: horizontalMargin,
                      top:  4,
                      left: 15,
                      right: 15),
                  child: Text(
                    error,
                    style: AppTextStyles.style12RedNormal,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : Container()
      ],
    );
  }
}