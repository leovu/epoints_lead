// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_chip.dart';

class CustomContentProjectItem extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final bool isStatus;
  final TextStyle styleTitle;
  final TextStyle styleContent;
  final Widget suffixChild;
  final TextAlign textAlign;
  final double paddingBottom;
  final bool haveDetail;
  final int maxLines;
  final bool startCrossAxis;
  final TextOverflow overflow;

  CustomContentProjectItem({
    this.title,
    this.content,
    this.color,
    this.isStatus = false,
    this.styleTitle,
    this.suffixChild,
    this.styleContent,
    this.textAlign,
    this.paddingBottom = 0.0,
    this.haveDetail = false,
    this.maxLines = 5,
    this.startCrossAxis = false,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: paddingBottom),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: !startCrossAxis
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Flexible(
              fit: FlexFit.loose,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title ?? "",
                  textAlign: textAlign,
                  style: styleTitle ??
                      AppTextStyles.style13BlackWeight400
                          .copyWith(color: AppColors.tabActiveColor),
                ),
              )),
          Container(
            width: 15.0/2,
          ),
          if (suffixChild != null) suffixChild,
          if (isStatus)
            Flexible(
                fit: FlexFit.loose,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: CustomChip(
                    backgroundColor: color,
                    text: content,
                    style: styleContent,
                  ),
                )),
          if (content != null)
          Flexible(
            fit: FlexFit.loose,
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  content ?? "",
                  style: styleContent ??
                      AppTextStyles.style14Black50Weight400
                          .copyWith(color: AppColors.tabActiveColor),
                  textAlign: TextAlign.right,
                  maxLines: maxLines,
                  overflow: overflow,
                )),
          ),
        ],
      ),
    );
  }
}

