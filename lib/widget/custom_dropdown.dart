import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';
import 'package:lead_plugin_epoint/widget/custom_shimer.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';

class CustomDropdown extends StatelessWidget {

  final List<CustomDropdownModel> menus;
  final CustomDropdownModel value;
  final Function(CustomDropdownModel) onChanged;
  final String hint;
  final String icon;
  final bool isText;

  CustomDropdown({this.icon, this.menus, this.value, this.onChanged, this.hint, this.isText = false});

  Widget _buildBody(String text, {bool isHint = false}){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: (menus ?? []).isNotEmpty
              ? Colors.transparent
              : Color(0xFFF6F6F6),
          border: Border.all(color: (menus ?? []).isNotEmpty
              ? Color(0xFFE5E5E5)
              : Color(0xFFF6F6F6),
          )
      ),
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: [
          if(icon != null)
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: CustomImageIcon(
                icon: icon,
                size: 16.0,
              ),
            ),
          Expanded(child: Text(
            text ?? "",
            style: TextStyle(
      fontSize: AppTextSizes.size14,
      color: isHint ?AppColors.hintColor: AppColors.black,
      fontWeight: FontWeight.normal),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          if(!isText)
            ...[
              Container(width: 15.0,),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20.0,
                color: AppColors.grey500Color,
              ),
            ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(isText){
      return _buildBody(value.text);
    }
    if(menus == null){
      return CustomShimmer(
        child: CustomSkeleton(
          height: 40.0,
          radius: 5.0,
        ),
      );
    }
    return DropdownButton(
      value: value,
      isExpanded: true,
      itemHeight: null,
      hint: hint == null? null: _buildBody(hint, isHint: true),
      selectedItemBuilder: (_){
        return menus.map((e) => _buildBody(e.text)).toList();
      },
      items: menus.map((e) => DropdownMenuItem(
          value: e,
          child: Text(
            e.text ?? "",
            style: TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.black,
      fontWeight: FontWeight.normal),
          ),
      )).toList(),
      onChanged: onChanged,
      underline: Container(),
      icon: Container(),
    );
  }
}

class CustomDropdownModel{
  final dynamic id;
  final String text;
  final dynamic data;

  CustomDropdownModel({this.id, this.text, this.data});
}