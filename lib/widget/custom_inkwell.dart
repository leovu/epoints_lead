// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {

  final Widget? child;
  final GestureTapCallback? ontap;

  CustomInkWell({this.child, this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: child,
        onTap: ontap 
    );
  }
}