import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';

class CustomTextField extends StatelessWidget {

  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? suffixIconData;
  final String? suffixIcon;
  final Color? borderColor;
  final Color? backgroundColor;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? readOnly;
  final bool? autofocus;
  final TextAlign? textAlign;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final GestureTapCallback? onSuffixTap;
  final GestureTapCallback? ontap;
  final bool? obscureText;

  CustomTextField({
    this.focusNode,
    this.controller,
    this.hintText,
    this.suffixIconData,
    this.suffixIcon,
    this.borderColor,
    this.backgroundColor,
    this.maxLines,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly,
    this.autofocus,
    this.textAlign,
    this.textInputAction,
    this.maxLength,
    this.onSubmitted,
    this.onChanged,
    this.onSuffixTap,
    this.ontap,
    this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: backgroundColor??Color(0xFFF6F6F6),
            border: borderColor == null?null:Border.all(color: borderColor!)
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: controller,
                style: TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.black,
      fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: hintText,
                    hintStyle: TextStyle(
      fontSize: 14.0,
      color: AppColors.hintColor,
      fontWeight: FontWeight.normal),
                    border: InputBorder.none
                ),
                maxLines: maxLines ?? 1,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                enabled: !(readOnly ?? false),
                autofocus: autofocus ?? false,
                textInputAction: textInputAction,
                onSubmitted: onSubmitted,
                onChanged: onChanged,
                textAlign: textAlign ?? TextAlign.start,
                maxLength: maxLength,
                obscureText: obscureText ?? false,
              ),
            ),
            (suffixIcon == null && suffixIconData == null)?Container():InkWell(
              splashColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.only(right: 10.0),
                child: suffixIcon != null?CustomImageIcon(
                  icon: suffixIcon,
                  size: 20.0,
                  color: Color(0xFF9E9E9E),
                ):Icon(
                  suffixIconData,
                  size: 20.0,
                  color: Color(0xFF9E9E9E),
                ),
              ),
              onTap: onSuffixTap ,
            )
          ],
        ),
      ),
      onTap: ontap ,
    );
  }
}