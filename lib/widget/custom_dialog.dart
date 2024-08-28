
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_scaffold.dart';

class CustomDialog extends StatelessWidget {

  final Widget screen;
  final bool bottom;
  final bool cancelable;
  final List<KeyboardActionsItem>? actions;

  CustomDialog({
    required this.screen,
    this.bottom = false,
    this.cancelable = true,
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomScaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: SingleChildScrollView(
        child: Container(
          height: AppSizes.screenHeight,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              GestureDetector(
                onTap: cancelable?() => Navigator.of(context).pop():null,
              ),
              Column(
                mainAxisAlignment: bottom?MainAxisAlignment.end:MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: AppSizes.maxPadding),
                    child: screen,
                  )
                ],
              )
            ],
          ),
        ),
      ),
      actions: actions??[],
    );
  }
}