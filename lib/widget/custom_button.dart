import 'package:auto_size_text_plus/auto_size_text_plus.dart';
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';

class CustomButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? borderColor;
  final String? icon;
  final String? text;
  final TextStyle? style;
  final GestureTapCallback? ontap;
  final bool isExpand;
  final bool isIcon;
  final Color? iconColor;
  final bool? enable;
  final double? heightButton;
  final Gradient? gradient;
  final double marginHorizontal;
  final double marginVertical;
  final double heightIcon;
  final double widthIcon;
  final double radius;

  CustomButton(
      {this.backgroundColor,
      this.borderColor,
      this.icon,
      this.text,
      this.style,
      this.ontap,
      this.isExpand = true,
      this.isIcon = false,
      this.iconColor,
      this.enable = true,
      this.heightButton,
      this.gradient,
      this.marginHorizontal = 0.0,
      this.marginVertical = 0.0,
      this.heightIcon = 20.0,
      this.widthIcon = 20.0,
      this.radius = AppRadius.md});

  bool get _isPrimary =>
      enable! &&
      gradient == null &&
      borderColor == null &&
      (backgroundColor == null || backgroundColor == AppColors.primaryColor);

  bool get _isOutline =>
      borderColor != null &&
      (backgroundColor == null ||
          backgroundColor == Colors.transparent ||
          backgroundColor == AppColors.white ||
          backgroundColor == Colors.white);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: marginHorizontal, vertical: marginVertical),
          decoration: _isPrimary
              ? AppGlass.primaryButton(radius: radius)
              : BoxDecoration(
                  color: enable!
                      ? (_isOutline
                          ? AppGlass.surface
                          : (gradient == null ? backgroundColor : null))
                      : AppColors.primaryLightColor,
                  gradient: enable! ? gradient : null,
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  border: borderColor == null
                      ? null
                      : Border.all(
                          color: borderColor == AppColors.primaryColor
                              ? AppColors.primaryColor.withValues(alpha: 0.4)
                              : borderColor!,
                          width: 1.0,
                          style: BorderStyle.solid)),
          height: heightButton != null ? heightButton : 48.0,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             if(icon!=null) Container(
                      width: widthIcon,
                      height: heightIcon,
                      margin: EdgeInsets.only(right: 10.0),
                      child: isIcon
                          ? CustomImageIcon(
                              icon: icon,
                              color: iconColor ?? AppColors.white,
                              // (enable
                              //     ? AppColors.white
                              //     : AppColors.grey600),
                              size: 20.0,
                            )
                          : Image.asset(
                              icon!,
                              width: 20,
                            ),
                    ),
              isExpand
                  ? Flexible(
                      fit: FlexFit.loose,
                      child: AutoSizeText(
                        text!,
                        style: style ??
                            AppTextStyles.style15WhiteNormal.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 1,
                        // enable
                        //     ? AppColors.white
                        //     : AppColors.grey600),
                      ))
                  : Text(
                      text!,
                      style: style ??
                          AppTextStyles.style15WhiteNormal.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                      // enable ? AppColors.white : AppColors.grey600),
                    )
            ],
          ),
        ),
        onTap: enable! ? ontap  : null);
  }
}
