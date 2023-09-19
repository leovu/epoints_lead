

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar_with_url.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';

class CustomChip extends StatelessWidget {
  final Color? backgroundColor;
  final String? text;
  final TextStyle? style;
  final GestureTapCallback? ontap;
  final String? icon;
  final bool iconAsset;
  final double? radius;
  final Color? borderColor;
  final GestureTapCallback? onClose;
  final EdgeInsetsGeometry? padding;
  final IconData? icons;
  final bool isExpand;
  final String? topIcon;
  final double? iconRadius;
  final double iconSize;

  CustomChip({
    this.backgroundColor,
    this.text,
    this.style,
    this.ontap,
    this.icon,
    this.iconAsset = true,
    this.radius,
    this.borderColor,
    this.onClose,
    this.padding,
    this.icons,
    this.isExpand = false,
    this.topIcon,
    this.iconRadius,
    this.iconSize = 12
  });

  Widget _buildText(){
    return AutoSizeText(
      text??"",
      style: style??AppTextStyles.style20WhiteBold,
      minFontSize: 1,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    if(text == null && icons == null){
      return Container();
    }

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor??AppColors.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(radius??(onClose == null
                ? topIcon != null
                ? 5.0
                : 100.0
                : 5.0))),
            border: borderColor == null?null:Border.all(
                color: borderColor!,
                width: 1.0,
                style: BorderStyle.solid
            )
        ),
        padding: padding??(onClose == null?EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: isExpand?2.0:AppSizes.maxPadding!
        ):EdgeInsets.only(left: AppSizes.minPadding!)),
        child: icons != null
            ? Icon(
          icons,
          size: iconSize,
          color: AppColors.white,
        )
            : Column(
          children: [
            if(topIcon != null)
              ...[
                CustomImageIcon(
                  icon: topIcon,
                  size: 30.0,
                  color: style == null ? AppColors.white : style!.color,
                ),
                SizedBox(height: AppSizes.minPadding,)
              ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: isExpand?MainAxisSize.max:MainAxisSize.min,
              children: [
                icon == null?Container():iconAsset?ImageIcon(
                  AssetImage(icon!),
                  size: iconSize,
                  color: AppColors.white,
                ):CustomNetworkImage(
                    width: iconSize,
                    height: iconSize,
                    url: icon,
                  radius: iconRadius,
                ),
                icon == null?Container():Container(width: 5.0,),
                isExpand?Expanded(
                  child: _buildText(),
                ):_buildText(),
                if(onClose != null)
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.minPadding!),
                      child: Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 12.0,
                      ),
                    ),
                    onTap: onClose ,
                  )
              ],
            )
          ],
        ),
      ),
      onTap: ontap ,
    );
  }
}

class CustomChipSelected extends StatelessWidget {

  final String? text;
  final String? icon;
  final dynamic type;
  final dynamic selected;
  final bool isExpanded;
  final GestureTapCallback? ontap;
  final bool? enable;

  CustomChipSelected({
    this.text,
    this.icon,
    this.type,
    this.selected,
    this.isExpanded = false,
    this.ontap,
    this.enable
  });

  @override
  Widget build(BuildContext context) {
    bool _enable = enable ?? true;

    TextStyle style;
    Color backgroundColor, borderColor;

    if(_enable){
      if(type == selected){
        style = AppTextStyles.style14WhiteNormal;
        backgroundColor = AppColors.primaryColor;
        borderColor = AppColors.primaryColor;
      }
      else{
        style = AppTextStyles.style14PrimaryRegular;
        borderColor = AppColors.primaryColor;
        backgroundColor = Colors.transparent;
      }
    }
    else{
      style = AppTextStyles.style14HintNormal;
      borderColor = AppColors.hintColor;
      backgroundColor = Colors.transparent;
    }

    GestureTapCallback? _onTap = _enable ? ontap : null;

    return isExpanded?CustomChip(
      text: text,
      style: style,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      icon: icon,
      ontap: _onTap,
    ):Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomChip(
          text: text,
          style: style,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          topIcon: icon,
          ontap: _onTap,
        )
      ],
    );
  }
}

class ContainerChipSelected extends StatelessWidget {

  final String? title;
  final EdgeInsetsGeometry? titlePadding;
  final Widget? titleWidget;
  final List<CustomChipSelected>? children;
  final Widget? child;

  ContainerChipSelected({this.title, this.titlePadding, this.titleWidget, this.children, this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: titlePadding ?? EdgeInsets.symmetric(
            horizontal: AppSizes.maxPadding!,
            vertical: AppSizes.minPadding!
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title ?? "",
                  style: AppTextStyles.style18PrimaryBold,
                ),
              ),
              titleWidget??Container()
            ],
          ),
        ),
        if(children != null)
          Container(
            color: AppColors.white,
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.maxPadding!,
                vertical: AppSizes.minPadding!
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSizes.minPadding!,
                  runSpacing: AppSizes.minPadding!,
                  children: children!,
                ),
                child == null?Container():Container(
                  padding: EdgeInsets.only(top: AppSizes.maxPadding!),
                  child: child,
                )
              ],
            ),
          )
      ],
    );
  }
}