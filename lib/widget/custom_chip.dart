
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';
import 'package:lead_plugin_epoint/widget/custom_inkwell.dart';

class CustomChip extends StatelessWidget {
  final String text;
  final Widget customText;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final TextStyle style;
  final Function onTap;
  final String icon;
  final Color iconColor;
  final radius;
  final Gradient gradient;

  CustomChip(
      {this.text,
      this.customText,
      this.backgroundColor,
      this.borderColor,
      this.padding,
      this.style,
      this.onTap,
      this.icon,
      this.iconColor,
      this.radius,
      this.gradient});

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: backgroundColor ?? AppColors.greenLightColor,
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(radius ?? 1000),
                  border: borderColor == null
                      ? null
                      : Border.all(
                          color: borderColor ?? AppColors.greenBorderColor)),
              padding: padding ??
                  EdgeInsets.symmetric(
                      vertical: 15.0 / 2,
                      horizontal: 15.0),
              child: Row(
                children: [
                  if (icon != null)
                    CustomImageIcon(
                        icon: icon,
                        size: 16.0,
                        color: iconColor ?? AppColors.white),
                  if (icon != null) Container(width: 15.0 / 2),
                  customText ??
                      Text(
                        text ?? "",
                        style: style ?? AppTextStyles.style15BlackNormal,
                      )
                ],
              ),
            )
          ],
        )
        );
  }
}