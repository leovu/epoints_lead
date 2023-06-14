import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/constant.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/container_scrollable.dart';

class ContainerDataBuilder extends StatelessWidget {

  final dynamic data;
  final Widget? emptyBuilder;
  final bool emptyShinkWrap;
  final Widget? skeletonBuilder;
  final CustomBodyBuilder bodyBuilder;
  final CustomRefreshCallback? onRefresh;
  final ScrollPhysics? emptyPhysics;

  ContainerDataBuilder({
    this.data,
    this.emptyBuilder,
    this.emptyShinkWrap = false,
    this.skeletonBuilder,
    required this.bodyBuilder,
    this.onRefresh,
    this.emptyPhysics
  }):assert(bodyBuilder != null);

  Widget? _buildBody(){
    if(data == null) {
      return skeletonBuilder;
    }

    if(data is List){
      Widget body;
      if(data.isEmpty){
        body = ListView(
          physics: emptyPhysics ?? AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: emptyShinkWrap,
          children: [
            emptyBuilder??Container()
          ],
        );
      }
      else{
        body = bodyBuilder();
      }

      return ContainerScrollable(
        child: body,
        onRefresh: onRefresh,
      );
    }

    return ContainerScrollable(
      child: bodyBuilder()??Container(),
      onRefresh: onRefresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppAnimation.duration,
      child: _buildBody(),
    );
  }
}

typedef CustomBodyBuilder = Widget Function();