import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';

class CustomDataNotFound extends StatelessWidget {
  final String? title;
  final String? content;
  final Color? color;
  final bool isTitle;
  final double? height;

  const CustomDataNotFound(
      {Key? key,
      this.title,
      this.content,
      this.color,
      this.isTitle = true, this.height})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width / 8,
            width: MediaQuery.of(context).size.width / 4,
            child: Icon(Icons.not_interested, color: Colors.grey[850],size: 50,),
          ),
          if (isTitle)
            Padding(
              padding: EdgeInsets.only(
                  top: 20.0,
                  right: 20.0,
                  left: 20.0,
                  bottom: 8.0),
              child: Text(
                  title ?? AppLocalizations.text(LangKey.searchNotFound)!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.style14Black50Weight400
                      .copyWith(color: Color.fromARGB(255, 112, 91, 91))),
            )
          else
            Container(height: 20.0),
          if (content != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(content!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.style14Black50Weight400
                      .copyWith(color: AppColors.grey500Color)),
            )
        ],
      ),
    );
  }
}


class CustomEmptyData extends StatelessWidget {
  final String? title;
  final String? content;
  final IconData icon;
  final Color? iconColor;
  final bool isTitle;
  final double? height;

  const CustomEmptyData({
    Key? key,
    this.title,
    this.content,
    this.icon = Icons.inbox_outlined,
    this.iconColor,
    this.isTitle = true,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height ?? MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: iconColor ?? Colors.grey[400],
          ),

          if (isTitle)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                title ?? AppLocalizations.text(LangKey.searchNotFound)!,
                textAlign: TextAlign.center,
                style: AppTextStyles.style14Black50Weight400.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            const SizedBox(height: 20),

          if (content != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                content!,
                textAlign: TextAlign.center,
                style: AppTextStyles.style14Black50Weight400.copyWith(
                  color: AppColors.grey500Color,
                ),
              ),
            ),
        ],
      ),
    );
  }
}