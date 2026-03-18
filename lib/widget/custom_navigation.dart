import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/widget/custom_alert_dialog.dart';
import 'package:lead_plugin_epoint/widget/custom_dialog.dart';
import 'package:lead_plugin_epoint/widget/custom_route.dart';
import 'package:lead_plugin_epoint/widget/progress_dialog.dart';

class CustomNavigator {
   static showCustomBottomDialog(BuildContext context, Widget screen,
      {bool root = true, isScrollControlled = true, GestureTapCallback? func, allowBack= false, disMissAble = true}) {

    return showModalBottomSheet(
        context: context,
        isDismissible: disMissAble,
        useRootNavigator: root,
        isScrollControlled: isScrollControlled,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            child: screen,
            onTap: func  ?? () {
              if(allowBack){
                Navigator.pop(context);
              }
            },
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  static canPop(BuildContext context) {
    ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    return parentRoute?.canPop ?? false;
  }

   static pop(BuildContext context, {dynamic object, bool root = true}) {
    if (object == null)
      Navigator.of(context, rootNavigator: root).pop();
    else
      Navigator.of(context, rootNavigator: root).pop(object);
  }

   static push(BuildContext context, Widget screen,
      {bool root = true, bool opaque = true}) {
    return Navigator.of(context, rootNavigator: root).push(opaque?CustomRoute(
      page: screen,
    ):CustomRouteDialog(
        page: screen
    ));
  }

    static showCustomAlertDialog(BuildContext context, String? title, String? content,
      {
        bool root = true,
        GestureTapCallback? onSubmitted,
        String? textSubmitted,
        Color? colorSubmitted,
        String? textSubSubmitted,
        GestureTapCallback? onSubSubmitted,
        bool enableCancel = false,
        bool cancelable = true,
        bool isTicket = false,
        bool showSubmitted = true,
        Widget? child
}) {
    return push(
        context,
        CustomDialog(
          screen: CustomAlertDialog(
              title: title,
              content: content,
              textSubmitted: textSubmitted,
              colorSubmitted: colorSubmitted,
              onSubmitted: onSubmitted,
              textSubSubmitted: textSubSubmitted,
              onSubSubmitted: onSubSubmitted,
              enableCancel: enableCancel,
              isTicket: isTicket,
              showSubmitted: showSubmitted,
              child: child
          ),
          cancelable: cancelable,
        ),
        opaque: false,
        root: root);
  }

    static ProgressDialog? _pr;
  static showProgressDialog(BuildContext? context) {
    if (_pr == null) {
      _pr = ProgressDialog(context);
      _pr!.show();
    }
  }

   static hideProgressDialog() {
    if (_pr != null && _pr!.isShowing()) {
      _pr!.hide();
      _pr = null;
    }
  }

  
}