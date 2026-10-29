import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;

class CustomGlassSurface extends StatelessWidget {
  final Widget? child;
  final double radius;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isSheet;

  const CustomGlassSurface(
      {Key? key,
      this.child,
      this.radius = AppRadius.card + 6.0,
      this.height,
      this.padding,
      this.margin,
      this.isSheet = false})
      : super(key: key);

  const CustomGlassSurface.sheet(
      {Key? key,
      this.child,
      this.radius = AppRadius.sheet + 8.0,
      this.height,
      this.padding,
      this.margin})
      : isSheet = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return lg.GlassContainer(
      useOwnLayer: true,
      settings: AppGlass.sheetSettings,
      shape: lg.LiquidRoundedSuperellipse(borderRadius: radius),
      clipBehavior: Clip.antiAlias,
      height: height,
      padding: padding,
      margin: margin ??
          (isSheet
              ? EdgeInsets.fromLTRB(
                  8.0, 0.0, 8.0, 8.0 + MediaQuery.paddingOf(context).bottom)
              : null),
      child: child,
    );
  }
}
