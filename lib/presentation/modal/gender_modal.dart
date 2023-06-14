import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';

class GenderModal extends StatefulWidget {
  const GenderModal({ Key? key }) : super(key: key);

  @override
  _GenderModalState createState() => _GenderModalState();
}

class _GenderModalState extends State<GenderModal> {

  int index = 0;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 1.0, color: Color(0xFFC3C8D3), style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10.0)),
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 5.0),
      margin: EdgeInsets.only(bottom: 15.0 / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5.0),
                  height: 20.0,
                  width: 20.0,
                  child: Image.asset(Assets.iconSex),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    AppLocalizations.text(LangKey.sex)!,
                    style: AppTextStyles.style15BlackNormal,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                // color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: ()  {

                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.darkGrey,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(right: 5.0),
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            right: 4.0,
                          ),
                          height: 20.0,
                          width: 20.0,
                          child: Image.asset(Assets.iconMale),
                        ),
                        Text(
                          AppLocalizations.text(LangKey.male)!,
                          style: TextStyle(
                              fontSize: AppTextSizes.size15,
                              color: index == 1 ? Colors.black : Color(0xFF9E9E9E),
                              fontWeight: FontWeight.normal),
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.darkGrey,
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(right: 5.0),
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 4.0,
                        ),
                        height: 20.0,
                        width: 20.0,
                        child: Image.asset(Assets.iconFemale),
                      ),
                      Text(
                        AppLocalizations.text(LangKey.female)!,
                        style: TextStyle(
                            fontSize: AppTextSizes.size15,
                            color: index == 2 ? Colors.black : Color(0xFF9E9E9E),
                            fontWeight: FontWeight.normal),
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                      color: AppColors.darkGrey,
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(right: 5.0),
                  padding: EdgeInsets.only(
                      top: 3.0, bottom: 3.0, left: 8.0, right: 8.0),
                  child: Center(
                    child: Text(
                      AppLocalizations.text(LangKey.other)!,
                      style: TextStyle(
                          fontSize: AppTextSizes.size15,
                          color: index == 3 ? Colors.black : Color(0xFF9E9E9E),
                          fontWeight: FontWeight.normal),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}