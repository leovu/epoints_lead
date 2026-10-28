import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lead_plugin_epoint/common/constant.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/container_scrollable.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<KeyboardActionsItem>? actions;
  final String? title;
  final Widget? body;
  final CustomRefreshCallback? onRefresh;
  final bool? isBottomSheet;

  CustomBottomSheet(
      {this.actions,
      this.title,
      this.body,
      this.onRefresh,
      this.isBottomSheet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // actions: actions,
      // isBottomSheet: isBottomSheet ?? true,
      body: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: MediaQuery.of(context).padding.top + 15.0,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: InkWell(
                child: Container(
                  decoration: AppGlass.sheet(),
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppGlass.sheetRadius)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.55),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                      stops: [0.0, 0.06],
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: AppGlass.grabber(),
                      ),
                      title == null
                          ? Container()
                          : Container(
                              height: kToolbarHeight,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: AppColors.primaryColorMix))),
                              child: Row(
                                children: [
                                  InkWell(
                                    child: Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.close,
                                        color: AppColors.textSecondaryColor,
                                        size: 20.0,
                                      ),
                                    ),
                                    onTap: () => Navigator.pop(context),
                                  ),
                                  Expanded(
                                    child: Text(
                                      title!,
                                      style: TextStyle(
                                          fontSize: AppTextSizes.size17,
                                          color: AppColors.textTitleColor,
                                          fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    width: 40.0,
                                  )
                                ],
                              ),
                            ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: onRefresh == null
                            ? (body ?? Container())
                            : ContainerScrollable(
                                child: body ?? Container(),
                                onRefresh: onRefresh),
                      )
                    ],
                  ),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
