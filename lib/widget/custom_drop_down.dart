
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';
import 'package:lead_plugin_epoint/widget/custom_inkwell.dart';

class CustomDropDown extends StatelessWidget {

  final String? suffixIcon;
  final Color? suffixIconColor;
  final double? suffixSize;
  final Color? backgroundColor;
  final GestureTapCallback? onSuffixIconTap;
  final String? prefixIcon;
  final Color? prefixIconColor;
  final GestureTapCallback? onPrefixIconTap;
  final GestureTapCallback? ontap;
  final Widget? suffixChild;
  final TextOverflow? overflow;
  final double? suffixChildMargin;

  final TextStyle? hintStyle;

  final String? hintText;
  const CustomDropDown({Key? key, this.suffixIcon, this.suffixIconColor, this.suffixSize, this.backgroundColor, this.onSuffixIconTap, this.prefixIcon, this.prefixIconColor, this.onPrefixIconTap, this.hintText, this.ontap, this.suffixChild, this.hintStyle, this.overflow, this.suffixChildMargin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color:backgroundColor?? AppColors.colorBgTextField,
          border: Border.all(
              width: 1.0,
              color:AppColors.lightGrey,
              style: BorderStyle.solid)),
      child: CustomInkWell(
        ontap: ontap,
        child: Row(
          children: [
            if (prefixIcon != null)
              InkWell(
                // ignore: sort_child_properties_last
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: CustomImageIcon(
                    icon: prefixIcon,
                    size: 20.0,
                    color: prefixIconColor ?? AppColors.primaryColor,
                  ),
                ),
                onTap: onPrefixIconTap  ?? ontap ,
              ),
            Expanded(
                child: Container(
                  padding:  (prefixIcon == null)
                      ? EdgeInsets.only(
                      left: 20.0,
                      top:  10.0,
                      bottom: 10.0)
                      : EdgeInsets.symmetric(
                    vertical:  10.0,
                  ),
                  child: Text(
                    hintText??"",
                    textAlign: TextAlign.start,
                    style: hintStyle??AppTextStyles.style13BlackWeight400,
                    overflow: overflow,
                  ),
                )
            ),
            if (suffixIcon != null || suffixChild != null)
              suffixChild??CustomInkWell(
                // ignore: sort_child_properties_last
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: suffixChildMargin??10.0,
                  ),
                  child: CustomImageIcon(
                    icon: suffixIcon,
                    size: suffixSize ?? 20.0,
                    color: suffixIconColor ?? AppColors.primaryColor,
                  ),
                ),
                ontap: onSuffixIconTap ?? ontap,
              )
          ],
        ),
      ),
    );
  }
}
