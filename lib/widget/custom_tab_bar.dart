import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';

class CustomTabBar extends StatelessWidget {
  final bool isExpanded;
  final List<CustomModelTabBar>? tabs;
  final AutoSizeGroup? group;
  final TabController? controller;

  CustomTabBar(
      {this.tabs, this.group, this.controller, this.isExpanded = true});

  Widget _buildTitle(CustomModelTabBar model){
    return AutoSizeText(
      model.name!,
      maxLines: 1,
      group: group ?? AutoSizeGroup(),
      minFontSize: 6.0,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return tabs == null?Container():TabBar(
      labelColor: AppColors.primaryColor,
      indicatorWeight: 2.0,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: AppColors.primaryColor,
      unselectedLabelStyle: TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold),
      labelStyle: AppTextStyles.style16PrimaryBold,
      labelPadding: EdgeInsets.symmetric(horizontal: isExpanded?0.0:20.0),
      isScrollable: true,
      tabs: tabs!.map((model){
        return Tab(
            child: Container(
              width: isExpanded
                  ? (MediaQuery.of(context).size.width - 20.0 * 2) / tabs!.length
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  model.icon == null?Container():Container(
                      padding: EdgeInsets.only(right: 5.0),
                      child: ImageIcon(
                        AssetImage(model.icon!),
                        size: 20,
                      )
                  ),
                  isExpanded?Flexible(
                      fit: FlexFit.loose,
                      child: _buildTitle(model)
                  ):_buildTitle(model)
                ],
              )
            )
        );
      }).toList(),
      controller: controller,
    );
  }
}

class CustomTabBarView extends StatelessWidget {
  final List<CustomModelTabBar>? tabs;
  final TabController? controller;
  final ScrollPhysics? physics;

  CustomTabBarView({this.tabs, this.controller, this.physics});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        controller: controller,
        children: tabs!.map((model) => model.child ?? Container()).toList(),
      physics: physics,
    );
  }
}

class CustomModelTabBar {
  final String? name;
  final String? icon;
  final Widget? child;

  CustomModelTabBar({this.name, this.icon, this.child});
}