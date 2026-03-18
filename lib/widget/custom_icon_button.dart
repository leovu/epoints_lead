import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';
import 'package:lead_plugin_epoint/widget/custom_inkwell.dart';

class CustomIconButton extends StatelessWidget {

  final GestureTapCallback? ontap;
  final String? icon;
  final Widget? child;
  final Color? color;
  final bool isText;

  CustomIconButton({
    this.child,
    this.icon,
    this.ontap,
    this.color,
    this.isText = false
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      ontap: ontap,
      child: Container(
        width: isText?null:48.0,
        height: 48.0,
        padding: EdgeInsets.all(48.0 / 5),
        child: Center(
          child: child??CustomImageIcon(
            icon: icon,
            color: color??AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}