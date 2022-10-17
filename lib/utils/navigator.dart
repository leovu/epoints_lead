import 'package:flutter/material.dart';

class LeadNavigator {
//   static pushViewController(BuildContext context, Widget screen) {
//   Navigator.of(context, rootNavigator: true).push(
//         PageRouteBuilder(
//           pageBuilder: (BuildContext context, Animation<double> animation,
//               Animation<double> secondaryAnimation) =>
//               screen,
//           transitionDuration: Duration.zero,
//           barrierDismissible: false,
//           barrierColor: Colors.black45,
//           opaque: false,
//         ),
//       );
// }


static push(BuildContext context, Widget screen,
      {bool root = true,
      bool opaque = true,
      String routeName,
      ScreenArguments arguments}) {
    // Navigator.of(context, rootNavigator: root).removeHUD();
    String name =
        screen.runtimeType.toString().replaceAll('Screen', '') + "Screen";
    return Navigator.of(context, rootNavigator: root).push(opaque
        ? CustomRoute(page: screen, routeName: routeName, arguments: arguments)
        : CustomRouteDialog(
            page: screen, routeName: routeName, arguments: arguments));


  }
}

class CustomRouteDialog extends PageRouteBuilder {
  final Widget page;
  final String routeName;
  final ScreenArguments arguments;
  CustomRouteDialog({
    this.arguments,
    this.page,
    this.routeName,
  }) : super(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(animation),
                child: child,
              );
            },
            opaque: false);
  @override
  RouteSettings get settings => opaque
      ? RouteSettings(
          name: routeName ?? page.runtimeType.toString(), arguments: arguments)
      : super.settings;
}

class ScreenArguments {
  final String title;
  final dynamic model;

  ScreenArguments(this.model,{this.title});
}

class CustomRoute extends MaterialPageRoute {
  final Widget page;
  final String routeName;
  final ScreenArguments arguments;
  CustomRoute({this.page, this.routeName, this.arguments})
      : super(builder: (context) => page);

  @override
  RouteSettings get settings => RouteSettings(
      name: routeName ?? page.runtimeType.toString(), arguments: arguments);
}


