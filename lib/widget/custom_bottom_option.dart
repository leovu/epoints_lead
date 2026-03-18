import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/constant.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/container_data_builder.dart';
import 'package:lead_plugin_epoint/widget/custom_bottom.dart';
import 'package:lead_plugin_epoint/widget/custom_empty.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';
import 'package:lead_plugin_epoint/widget/custom_line.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_shimer.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';

class CustomBottomOption extends StatefulWidget {
  final List<CustomBottomOptionModel>? options;
  final CustomRefreshCallback? onRefresh;
  final bool shrinkWrap;
  final GestureTapCallback? onConfirm;

  CustomBottomOption(
      {this.options, this.onRefresh, this.shrinkWrap = true, this.onConfirm});

  @override
  CustomBottomOptionState createState() => CustomBottomOptionState();
}

class CustomBottomOptionState extends State<CustomBottomOption> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _onSelected(CustomBottomOptionModel model) {
    model.isSelected = !(model.isSelected ?? false);
    setState(() {});
  }

  Widget _buildEmpty() {
    return CustomEmpty(
      title: AppLocalizations.text(LangKey.data_empty),
    );
  }

  Widget _buildContainer(List<Widget> children) {
    return CustomListView(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.maxPadding),
        shrinkWrap: widget.shrinkWrap,
        separator: CustomLine(),
        children: children);
  }

  @override
  Widget build(BuildContext context) {
    double _iconSize = 15.0;
    return ContainerDataBuilder(
      data: widget.options,
      emptyBuilder: _buildEmpty(),
      emptyShinkWrap: widget.shrinkWrap,
      skeletonBuilder: _buildContainer(List.generate(
          4,
          (index) => Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.maxPadding),
                child: CustomShimmer(
                  child: Row(
                    children: [
                      CustomSkeleton(
                        width: _iconSize,
                        height: _iconSize,
                        radius: _iconSize,
                      ),
                      SizedBox(
                        width: AppSizes.minPadding,
                      ),
                      CustomSkeleton(
                        width: AppSizes.maxWidth! * 0.4,
                      )
                    ],
                  ),
                ),
              ))),
      bodyBuilder: () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: _buildContainer(widget.options!
              .map((e) => InkWell(
            child: Container(
              padding:
              EdgeInsets.symmetric(vertical: AppSizes.maxPadding),
              child: Row(
                children: [
                  if (e.icon != null || e.image != null)
                    Container(
                      padding:
                      EdgeInsets.only(right: AppSizes.minPadding),
                      child: e.icon != null
                          ? CustomImageIcon(
                        icon: e.icon,
                        size: _iconSize,
                        color:
                        e.textColor ?? AppColors.grey200Color,
                      )
                          : Image.asset(
                        e.image!,
                        width: _iconSize,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      e.text ?? "",
                      style: AppTextStyles.style15BlackNormal.copyWith(
                          color: e.textColor ?? AppColors.black),
                    ),
                  ),
                  if (e.isSelected != null && e.isSelected!)
                    Container(
                      padding:
                      EdgeInsets.only(left: AppSizes.minPadding),
                      child: Icon(
                        Icons.check,
                        color: AppColors.primaryColor,
                        size: _iconSize,
                      ),
                    )
                ],
              ),
            ),
            onTap: widget.onConfirm == null
                ? e.onTap
                : () => _onSelected(e),
          ))
              .toList())),
          if (widget.onConfirm != null)
            CustomBottom(
              text: AppLocalizations.text(LangKey.confirm),
              ontap: widget.onConfirm,
            )
        ],
      ),
      onRefresh: widget.onRefresh,
    );
  }
}

class CustomBottomOptionModel {
  dynamic id;
  String? icon;
  String? image;
  String? text;
  Color? textColor;
  bool? isSelected;
  GestureTapCallback? onTap;

  CustomBottomOptionModel(
      {this.id,
      this.icon,
      this.image,
      this.text,
      this.textColor,
      this.isSelected,
      this.onTap});
}
