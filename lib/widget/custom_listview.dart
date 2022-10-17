
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/widget/custom_scroll_behavior.dart';

class CustomListView extends StatelessWidget {

  final ScrollController controller;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double separatorPadding;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final Widget separator;
  final bool isVertical;

  CustomListView({
    this.controller,
    this.children,
    this.padding,
    this.separatorPadding,
    this.physics,
    this.shrinkWrap, this.separator, this.isVertical=true
  });

  @override
  Widget build(BuildContext context) {
    if((children??[]).isEmpty){
      return Container();
    }
    return ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: ListView.separated(
            controller: controller??ScrollController(),
            padding: padding??EdgeInsets.all(20),
            physics: physics?? const ClampingScrollPhysics(),
            shrinkWrap: shrinkWrap??false,
            scrollDirection: isVertical?Axis.vertical:Axis.horizontal,
            itemBuilder: (_, index) => children[index],
            separatorBuilder: (_, index) => (separator??Container(height: separatorPadding??15,)),
            itemCount: children.length
        ),
      );
  }
}