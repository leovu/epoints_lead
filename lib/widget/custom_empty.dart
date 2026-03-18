import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';

class CustomEmpty extends StatelessWidget {
  final String? title;
  final String? text;
  final String? image;
  final EdgeInsetsGeometry? padding;
  final GestureTapCallback? ontap;

  CustomEmpty({this.title, this.text, this.image, this.padding, this.ontap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width * 0.1,
              horizontal: 20.0),
      child: Column(
        children: [
          Image.asset(
            image ?? Assets.iconSearch,
            width: 20.0,
          ),
          Container(
            height: 10.0,
          ),
          Text(
            title ?? "",
            style: TextStyle(
                fontSize: 13.0,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
          if (text != null)
            Column(
              children: [
                Container(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: text,
                      backgroundColor: Colors.transparent,
                      borderColor: AppColors.primaryColor,
                      style: TextStyle(
                          fontSize: AppTextSizes.size14,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                      isExpand: false,
                      ontap: ontap,
                    )
                  ],
                )
              ],
            )
        ],
      ),
    );
  }
}
