import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final String? icon;
  final GestureTapCallback? onClick;

  CircularButton(
      {this.color, this.width, this.height, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: InkWell(child: Image.asset(
              icon!,
              scale: 2.5,
            ), enableFeedback: true, onTap: onClick ),
    );
  }
}