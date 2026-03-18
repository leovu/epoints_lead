import 'package:flutter/material.dart';

class ContainerScrollable extends StatelessWidget {

  final Widget? child;
  final Future<void> Function()? onRefresh;

  ContainerScrollable({this.child, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return onRefresh == null
        ? child!
        : RefreshIndicator(
        child: child!,
        onRefresh: onRefresh!
    );
  }
}
