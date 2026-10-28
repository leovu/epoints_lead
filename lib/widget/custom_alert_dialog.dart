import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final String? textSubmitted;
  final GestureTapCallback? onSubmitted;
  final String? textSubSubmitted;
  final GestureTapCallback? onSubSubmitted;
  final Color? colorSubmitted;
  final bool enableCancel;
  final bool isTicket;
  final Widget? child;
  final bool showSubmitted;

  CustomAlertDialog(
      {required this.title,
      this.content,
      this.onSubmitted,
      this.textSubmitted,
      this.onSubSubmitted,
      this.textSubSubmitted,
      this.colorSubmitted,
      this.enableCancel = false,
      this.isTicket = false,
      this.showSubmitted = true,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          decoration: AppGlass.dialog(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.maxPadding),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              AppSizes.sizeOnTap! - AppSizes.maxPadding),
                      child: Text(
                        title ?? "",
                        style: AppTextStyles.style20BlackBold
                            .copyWith(fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: AppSizes.minPadding,
                    ),
                    child ??
                        Text(
                          content ?? "",
                          style: AppTextStyles.style15BlackNormal
                              .copyWith(color: AppColors.textBodyColor),
                          textAlign: TextAlign.center,
                        ),
                    if (showSubmitted) ...[
                      SizedBox(
                        height: AppSizes.minPadding,
                      ),
                      CustomButton(
                        text: textSubmitted ??
                            AppLocalizations.text(LangKey.i_get_it),
                        backgroundColor:
                            colorSubmitted ?? AppColors.primaryColor,
                        ontap:
                            onSubmitted ?? () => CustomNavigator.pop(context),
                      ),
                    ],
                    textSubSubmitted == null
                        ? Container()
                        : Container(
                            padding: EdgeInsets.only(top: AppSizes.minPadding),
                            child: CustomButton(
                              text: textSubSubmitted,
                              backgroundColor: Colors.transparent,
                              borderColor: AppColors.primaryColor,
                              style: AppTextStyles.style15WhiteNormal.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600),
                              ontap: onSubSubmitted ??
                                  () => Navigator.of(context).pop(),
                            ))
                  ],
                ),
              )
            ],
          ),
        ),
        enableCancel
            ? InkWell(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.minPadding),
                  child: Icon(
                    Icons.close,
                    size: 22,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(),
              )
            : Container()
      ],
    );
  }
}
