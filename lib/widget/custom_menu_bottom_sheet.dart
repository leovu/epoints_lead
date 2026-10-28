import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';

import 'package:lead_plugin_epoint/widget/custom_button.dart';

class CustomMenuBottomSheet extends StatelessWidget {
  final Widget? widget;
  final String? title;
  final bool allowBack;
  final bool haveBnConfirm;
  final bool enableButton;
  final String? textConfirm;
  final GestureTapCallback? ontapConfirm;
  final Function? funcPop;
  CustomMenuBottomSheet(
      {this.widget,
      this.title,
      this.allowBack = true,
      this.haveBnConfirm = false,
      this.enableButton = true,
      this.textConfirm,
      this.ontapConfirm,
      this.funcPop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
          ),
          Flexible(
              fit: FlexFit.loose,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 12.0 * 1.5, vertical: 10.0),
                decoration: AppGlass.sheet(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: AppGlass.grabber(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (allowBack)
                          Opacity(
                            child: InkWell(
                              onTap: funcPop == null ? () => Navigator.of(context).pop() : () => funcPop,
                              child: Container(
                                width: 48.0,
                                height: 48.0,
                                padding: EdgeInsets.only(left: 20.0),
                                child: Icon(
                                  Icons.clear,
                                  color: AppColors.textSecondaryColor,
                                  size: 20.0,
                                ),
                              ),
                            ),
                            opacity: 1.0,
                          ),
                        Expanded(
                          child: Text(
                            title ?? "",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: AppColors.textTitleColor,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 48.0,
                        )
                      ],
                    ),
                    // CustomLine(),
                    if ((title ?? "") != "")
                      Divider(color: AppGlass.dividerColor),
                    Flexible(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: widget!),
                        if (haveBnConfirm)
                          CustomButton(
                            text: textConfirm ??
                                AppLocalizations.text(LangKey.confirm),
                            enable: enableButton,
                            ontap: ontapConfirm,
                          )
                      ],
                    )),
                    Container(
                      height: 15.0,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}