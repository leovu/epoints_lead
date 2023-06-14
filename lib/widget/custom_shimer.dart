import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {

  final Widget? child;

  CustomShimmer({this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color(0xFFD8D8D8),
      highlightColor: Colors.white,
      child: child!,
    );
  }
}