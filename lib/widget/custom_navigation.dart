import 'package:flutter/material.dart';

class CustomNavigator {
   static showCustomBottomDialog(BuildContext context, Widget screen,
      {bool root = true, isScrollControlled = true, Function func, allowBack= false, disMissAble = true}) {

    return showModalBottomSheet(
        context: context,
        isDismissible: disMissAble,
        useRootNavigator: root,
        isScrollControlled: isScrollControlled,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            child: screen,
            onTap: func ?? () {
              if(allowBack){
                Navigator.pop(context);
              }
            },
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  static canPop(BuildContext context) {
    ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
    return parentRoute?.canPop ?? false;
  }

  
}