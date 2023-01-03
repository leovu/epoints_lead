import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';
import 'package:lead_plugin_epoint/widget/custom_inkwell.dart';

class CustomItemBottomSheet extends StatelessWidget {
  final String text;
  final String subText;
  final Function function;
  final bool isSelected;
  final String icon;
  final bool isEdit;
  final Function funcEdit;
  final Widget iconChild;
  final Color color;
  final Color colorIcon;
  final bool isPadding;
  final bool isBorder;
  final bool hideIconCheck;
  final TextStyle textStyle;
  const CustomItemBottomSheet(this.text, this.function,
      {this.subText,
      this.isSelected = false,
      this.isBorder = true,
      this.icon,
      this.iconChild,
      this.color,
      this.textStyle,
      this.isPadding = true,
      this.isEdit = false,
      this.funcEdit,
      this.colorIcon,
      this.hideIconCheck = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: isBorder
                  ? BorderSide(color: Color(0xFFEFEFEF), width: 1)
                  : BorderSide.none)),
      child: Row(
        children: [
          Expanded(
              child: CustomInkWell(
            onTap: function,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: isPadding ? 24.0 : 0.0, vertical: 10.0),
              child: Row(
                children: [
                  if (icon != null || iconChild != null)
                    Container(
                      padding: EdgeInsets.only(
                        right: 20.0,
                      ),
                      child: CustomImageIcon(
                        icon: icon,
                        size: 20.0,
                        color: colorIcon ?? (color ?? Color(0xFF040C21)),
                        child: iconChild,
                      ),
                    ),
                  subText == null
                      ? Expanded(
                          child: Text(text ?? "",
                              style: textStyle ??
                                  TextStyle(
                                      fontSize: 15.0,
                                      color: (isSelected ?? false) ? AppColors.primaryColor : Color(0xFF040C21) ,
                                      fontWeight: (isSelected ?? false)
                                          ? FontWeight.w700
                                          : FontWeight.w400)))
                      : Expanded(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text ?? "",
                              style: textStyle ??
                                  TextStyle(
                                      fontSize: 14.0,
                                      color: color ?? Color(0xFF040C21),
                                      fontWeight: (isSelected ?? false)
                                          ? FontWeight.w700
                                          : FontWeight.w400),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 4.0),
                                child: Text(
                                  subText ?? "",
                                  style: textStyle ??
                                      TextStyle(
                                      fontSize: 14.0,
                                      color: color ?? Color(0xFF040C21),
                                      fontWeight: (isSelected ?? false)
                                          ? FontWeight.w700
                                          : FontWeight.w400),
                                )),
                          ],
                        )),
                  if (isSelected && !hideIconCheck)
                    Container(
                      width: 10.0,
                    ),
                  if (isSelected && !hideIconCheck)
                    Icon(Icons.check, color: AppColors.primaryColor,size: 20,),
                ],
              ),
            ),
          )),
          if (isEdit)
            Container(
              width: 10.0,
            ),
          if (isEdit)
            CustomInkWell(
              onTap: funcEdit,
              child: CustomImageIcon(
                icon: Assets.iconEdit,
                size: 10.0,
                color: AppColors.grey500Color,
              ),
            )
        ],
      ),
    );
  }
}
