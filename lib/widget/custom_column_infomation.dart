import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';
import 'package:lead_plugin_epoint/widget/custom_shimer.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';

class CustomColumnInformation extends StatelessWidget {

  final String? title;
  final Widget? titleSuffix;
  final dynamic titleIcon;
  final IconData? titleSuffixIcon;
  final String? content;
  final IconData? suffixIconData;
  final String? suffixIcon;
  final Widget? child;
  final Color? backgroundColor;
  final Color? borderColor;
  final TextStyle? titleStyle;
  final bool isRequired;
  final Function? onTap;
  final Function? onTitleTap;
  final bool enable;

  CustomColumnInformation({
    this.title,
    this.titleSuffix,
    this.titleIcon,
    this.titleSuffixIcon,
    this.content,
    this.suffixIconData,
    this.suffixIcon,
    this.child,
    this.backgroundColor,
    this.borderColor,
    this.titleStyle,
    this.isRequired = false,
    this.onTap,
    this.onTitleTap,
    this.enable = true,
  });

  final _titleIconSize = 18.0;

  Widget _buildSkeleton(){
    return CustomShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSkeleton(width: AppSizes.maxWidth! / 4,),
          Container(height: AppSizes.minPadding,),
          CustomSkeleton(
            height: AppSizes.maxPadding! * 2,
            radius: 5.0,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(title == null){
      return _buildSkeleton();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    if(titleIcon != null)
                      Padding(
                        padding: EdgeInsets.only(right: AppSizes.minPadding! / 2),
                        child: (titleIcon is IconData) ? Icon(
                          titleIcon,
                          size: _titleIconSize,
                          color: AppColors.primaryColor,
                        ): CustomImageIcon(
                          icon: titleIcon,
                          size: _titleIconSize,
                        ),
                      ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                            text: title,
                            style: titleStyle ?? AppTextStyles.style16BlackBold,
                            children: [
                              TextSpan(
                                text: isRequired?" *":"",
                                style: (titleStyle ?? AppTextStyles.style16BlackBold).copyWith(
                                    color: Colors.red
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                    if(titleSuffixIcon != null)
                      Padding(
                        padding: EdgeInsets.only(left: AppSizes.minPadding! / 2),
                        child: Icon(
                          titleSuffixIcon,
                          size: 18.0,
                          color: AppColors.primaryColor,
                        ),
                      ),
                  ],
                ),
              ),
              if(titleSuffix != null)
                titleSuffix!,
            ],
          ),
          onTap: onTitleTap as void Function()?,
        ),
        Container(height: AppSizes.minPadding,),
        InkWell(
          child: (child != null && enable) ? child : Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: backgroundColor ?? Color(0xFFF6F6F6),
                border: borderColor == null?null:Border.all(
                    color: borderColor!
                )
            ),
            padding: EdgeInsets.all(AppSizes.minPadding!),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    content ?? "",
                    style: AppTextStyles.style14BlackNormal,
                  ),
                ),
                (suffixIcon == null && suffixIconData == null)?Container():Container(
                  padding: EdgeInsets.only(left: AppSizes.minPadding!),
                  child: suffixIcon != null? CustomImageIcon(
                    icon: suffixIcon,
                    size: 20.0,
                    color: AppColors.grey500Color,
                  ): Icon(
                    suffixIconData,
                    size: 20.0,
                    color: AppColors.grey500Color,
                  ),
                )
              ],
            ),
          ),
          onTap: enable ? onTap as void Function()? : null,
        )
      ],
    );
  }
}