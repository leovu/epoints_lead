import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_icon_button.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget customTitle;
  final List<CustomOptionAppBar> options;
  final IconData icon;
  final Function onWillPop;

  CustomAppBar({this.title, this.customTitle, this.options, this.icon, this.onWillPop});

  Widget _buildIcon(int index) {
    CustomOptionAppBar model = options[index];
    return CustomIconButton(
        onTap: model.onTap,
        icon: model.icon,
        isText: model.text != null,
        color: Colors.white,
        child: model.text == null
            ? null
            : Text(
          options[index].text,
          style: AppTextStyles.style15PrimaryNormal,
        ));
  }

  @override
  Widget build(BuildContext context) {
    bool canPop = CustomNavigator.canPop(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal:15.0 +
                  ((options == null || options.length == 0)
                      ? (canPop ? 40.0 : 0.0)
                      : (options.length * 40.0))),
          child: customTitle ?? Center(
            child: Text(
              title,
              style: AppTextStyles.style17WhiteNormal,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Row(
          children: [
            Opacity(
              child: InkWell(
                onTap: canPop
                    ? (onWillPop ?? () => Navigator.pop(context))
                    : null,
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Icon(
                    icon ?? Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 15.0,
                  ),
                ),
              ),
              opacity: canPop ? 1.0 : 0.0,
            ),
            Expanded(
              child: Container(),
            ),
            (options == null || options.length == 0)
                ? Container()
                : Container(
              height: 40.0,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: 15.0),
                  itemCount: options.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) =>
                  options[index].child ?? _buildIcon(index)),
            )
          ],
        )
      ],
    );
  }
}

class CustomOptionAppBar {
  final String icon;
  final Function onTap;
  final bool showIcon;
  final Widget child;
  final String text;

  CustomOptionAppBar(
      {this.icon, this.showIcon = true, this.onTap, this.child, this.text});
}
