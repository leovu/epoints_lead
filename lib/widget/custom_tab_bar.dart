part of widget;
class CustomTabBar extends StatelessWidget {
  final bool isExpanded;
  final List<CustomModelTabBar>? tabs;
  final AutoSizeGroup? group;
  final TabController? controller;
  final TextStyle? unSelectedLabel;
  final TextStyle? labelStyle;
  final Color? labelColor;
  final Color? unSelectedLabelColor;
  final ValueChanged<int>? onTap;

  CustomTabBar(
      {this.tabs,
      this.group,
      this.controller,
      this.isExpanded = true,
      this.unSelectedLabel,
      this.labelStyle,
      this.labelColor,
      this.unSelectedLabelColor,
      this.onTap});

  Widget _buildTitle(CustomModelTabBar model) {
    Widget child = AutoSizeText(
      model.name!,
      maxLines: 1,
      group: group ?? AutoSizeGroup(),
      minFontSize: 6.0,
      textAlign: TextAlign.center,
    );
    return child;
  }

  Widget _buildTab(CustomModelTabBar model){
    return Container(
        width: isExpanded
            ? (AppSizes.maxWidth! - AppSizes.maxPadding * 2) /
            tabs!.length
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            model.icon == null
                ? Container()
                : Container(
                padding: EdgeInsets.only(right: 5.0),
                child: ImageIcon(
                  AssetImage(model.icon!),
                  size: 20,
                )),
            isExpanded
                ? Flexible(
                fit: FlexFit.loose, child: _buildTitle(model))
                : _buildTitle(model)
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return tabs == null
        ? Container()
        : TabBar(
            labelColor: labelColor ?? AppColors.primaryColor,
            indicatorWeight: 2.0,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: labelColor ?? AppColors.primaryColor,
            unselectedLabelStyle:
                unSelectedLabel ?? AppTextStyles.style16PrimaryBold,
            unselectedLabelColor: unSelectedLabelColor ?? null,
            labelStyle: labelStyle ?? AppTextStyles.style16PrimaryBold,
            labelPadding: EdgeInsets.symmetric(
                horizontal: isExpanded ? 0.0 : AppSizes.maxPadding),
            isScrollable: true,
            onTap: onTap,
            tabs: tabs!.map((model) {
              return Tab(child: _buildTab(model));
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
  final ValueStream<int?>? stream;
  final Widget? child;

  CustomModelTabBar({this.name, this.icon, this.child, this.stream});
}
