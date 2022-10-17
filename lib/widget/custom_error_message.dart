import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';

class CustomErrorMessage extends StatelessWidget {
  final String text;
  final String icon;
  final Color color;
  final double padding;
  final bool isCenter;
  final TextStyle textStyle;
  const CustomErrorMessage({Key key, this.text, this.icon, this.color, this.padding, this.isCenter=true, this.textStyle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AutoSizeGroup group = AutoSizeGroup();

    return Container(
      margin: EdgeInsets.all(padding??15.0),
      alignment: isCenter?Alignment.center:Alignment.centerLeft,
      child: Center(
        child: Row(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment: isCenter?MainAxisAlignment.center:MainAxisAlignment.start,
          children: [
            CustomImageIcon(icon: icon??Assets.iconError,color: color??AppColors.colorRed,size: 15.0,),
            Container(width: 15.0/2,),
            Flexible(
              fit: FlexFit.loose,
              child: AutoSizeText(
                text??"",
                group: group,
                textAlign: isCenter?TextAlign.center:TextAlign.start,
                style: textStyle??AppTextStyles.style12BlackW400
                    .copyWith(color:color??AppColors.colorRed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}