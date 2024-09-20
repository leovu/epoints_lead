library progress_dialog;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProgressDialog {
  bool _isShowing = false;

  BuildContext? buildContext;

  ProgressDialog(this.buildContext);

  show() {
    _showDialog();
    _isShowing = true;
  }

  bool isShowing() {
    return _isShowing;
  }

  hide() {
    _isShowing = false;
    Navigator.of(buildContext!).pop();
  }

  _showDialog() {
    Navigator.of(buildContext!, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: false,
        // settings: RouteSettings(name: AppKeys.keyHUD),
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return WillPopScope(
            child: Scaffold(
              backgroundColor: Colors.black.withOpacity(0.3),
              body: Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Platform.isAndroid?CircularProgressIndicator():CupertinoActivityIndicator(),
                ),
              ),
            ),
            onWillPop: () async => false,
          );
        },
      ),
    );
  }
}