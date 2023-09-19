import 'package:flutter/material.dart';

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

  
}