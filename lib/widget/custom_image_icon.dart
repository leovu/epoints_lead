import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';

class CustomImageIcon extends StatelessWidget {
  final Widget child;
  final String icon;
  final Color color;
  final double size;

  CustomImageIcon({
    this.icon,
    this.color,
    this.size, this.child
  });

  @override
  Widget build(BuildContext context) {
    return child??ImageIcon(
      AssetImage(icon),
      color: color??AppColors.primaryColor,
      size: size?? 24.0,
    );
  }
}