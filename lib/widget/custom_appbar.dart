import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_icon_button.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final Widget? customTitle;
  final List<CustomOptionAppBar>? options;
  final IconData? icon;
  final GestureTapCallback? onWillPop;

  CustomAppBar({this.title, this.customTitle, this.options, this.icon, this.onWillPop});

  Widget _buildIcon(int index) {
    CustomOptionAppBar model = options![index];
    if (model.text != null) {
      return CustomIconButton(
          ontap: model.ontap,
          isText: true,
          color: Colors.white,
          child: Text(
            options![index].text!,
            style: AppTextStyles.style15PrimaryNormal
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ));
    }
    return Center(
      child: Container(
        width: 36.0,
        height: 36.0,
        margin: EdgeInsets.only(left: 4.0),
        decoration: BoxDecoration(
          color: AppGlass.headerIconBackground,
          shape: BoxShape.circle,
        ),
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: model.ontap,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomImageIcon(
              icon: model.icon,
              size: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
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
                  ((options == null || options!.length == 0)
                      ? (canPop ? 40.0 : 0.0)
                      : (options!.length * 40.0))),
          child: customTitle ??
              Center(
                child: Text(
                  title!,
                  style: AppTextStyles.style17WhiteNormal
                      .copyWith(fontWeight: FontWeight.w600),
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
                    ? (onWillPop  ?? () => Navigator.pop(context))
                    : null,
                child: Container(
                  width: 36.0,
                  height: 36.0,
                  margin: EdgeInsets.only(left: 12.0),
                  decoration: BoxDecoration(
                    color: AppGlass.headerIconBackground,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon ?? Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18.0,
                  ),
                ),
              ),
              opacity: canPop ? 1.0 : 0.0,
            ),
            Expanded(
              child: Container(),
            ),
            (options == null || options!.length == 0)
                ? Container()
                : Container(
              height: 40.0,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: 15.0),
                  itemCount: options!.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) =>
                  options![index].child ?? _buildIcon(index)),
            )
          ],
        )
      ],
    );
  }
}

class CustomOptionAppBar {
  final String? icon;
  final GestureTapCallback? ontap;
  final bool showIcon;
  final Widget? child;
  final String? text;

  CustomOptionAppBar(
      {this.icon, this.showIcon = true, this.ontap, this.child, this.text});
}
