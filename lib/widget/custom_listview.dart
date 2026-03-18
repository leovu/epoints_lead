import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/constant.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/container_scrollable.dart';

class CustomListView extends StatefulWidget {

  final ScrollController? controller;
  final List<Widget>? children;
  final EdgeInsetsGeometry? padding;
  final double? separatorPadding;
  final ScrollPhysics? physics;
  final bool? shrinkWrap;
  final Widget? separator;
  final Axis? scrollDirection;
  final bool? showLoadmore;
  final Function? onLoadmore;
  final CustomRefreshCallback? onRefresh;
  final bool reverse;

  CustomListView({
    this.controller,
    this.children,
    this.padding,
    this.separatorPadding,
    this.physics,
    this.shrinkWrap,
    this.separator,
    this.scrollDirection,
    this.showLoadmore,
    this.onRefresh,
    this.onLoadmore,
    this.reverse = false
  }) : assert (onLoadmore == null || !(physics is NeverScrollableScrollPhysics));

  @override
  State<CustomListView> createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {

  bool _isLoadmore = false;

  _loadmore() async {
    if(!_isLoadmore){
      _isLoadmore = true;
      await widget.onLoadmore!();
      _isLoadmore = false;
    }
  }

  Widget _buildBody(){
    List<Widget> children = []..addAll(this.widget.children ?? []);
    if((widget.showLoadmore ?? false)){
      children.add(CustomContainerLoadmore());
    }

    return ListView.separated(
        reverse: widget.reverse,
        scrollDirection: widget.scrollDirection ?? Axis.vertical,
        controller: widget.controller,
        padding: widget.padding??EdgeInsets.all(AppSizes.maxPadding),
        physics: widget.physics ?? AlwaysScrollableScrollPhysics(),
        shrinkWrap: widget.shrinkWrap??false,
        itemBuilder: (_, index) {
          if(widget.onLoadmore != null && index >= (children.length/2)){
            _loadmore();
          }
          return children[index];
        },
        separatorBuilder: (_, index) => (widget.separator??Container(height: widget.separatorPadding??AppSizes.minPadding,)),
        itemCount: children.length,
        cacheExtent: AppSizes.maxHeight,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScrollable(
        child: _buildBody(),
        onRefresh: widget.onRefresh
    );
  }
}


class CustomContainerLoadmore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.sizeOnTap,
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}