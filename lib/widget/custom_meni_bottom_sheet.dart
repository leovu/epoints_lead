import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/utils/navigator.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';

class CustomMenuBottomSheet extends StatelessWidget {
  final Widget widget;
  final String title;
  final bool allowBack;
  final bool haveBnConfirm;
  final bool enableButton;
  final String textConfirm;
  final Function onTapConfirm;
  final Function funcPop;
  CustomMenuBottomSheet(
      {this.widget,
      this.title,
      this.allowBack = true,
      this.haveBnConfirm = false,
      this.enableButton = true,
      this.textConfirm,
      this.onTapConfirm,
      this.funcPop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Flexible(
              fit: FlexFit.loose,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 15.0 * 1.5,
                    vertical:  15.0 * 1.5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    )),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (allowBack)
                          Opacity(
                            child: InkWell(
                              onTap: funcPop?? () => Navigator.of(context).pop(),
                              child: Container(
                                width: 48.0,
                                height: 48.0,
                                padding:
                                EdgeInsets.only(left: 20.0),
                                child: Icon(Icons.clear,color: Colors.black,size: 15.0,),
                              ),
                            ),
                            opacity: 1.0,
                          ),
                        Expanded(
                          child: Text(
                            title ?? "",
                            style: TextStyle(
      fontSize: 16.0,
      color: Colors.black,
      fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 48.0,
                        )
                      ],
                    ),
                    // CustomLine(),
                    if((title??"")!="") Divider(),
                    if (haveBnConfirm)
                      Expanded(
                          child: Column(
                            children: [
                              Expanded(child: widget),
                              CustomButton(
                                text: textConfirm??AppLocalizations.text(LangKey.confirm),
                                enable: enableButton,
                                onTap: onTapConfirm,
                              )
                            ],
                          ))
                    else
                      widget,
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