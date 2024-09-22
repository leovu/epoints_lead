import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lead_plugin_epoint/model/response/detail_lead_info_deal_response_model.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/bloc/detail_potential_customer_bloc.dart';

import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/container_data_builder.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar_with_url.dart';
import 'package:lead_plugin_epoint/widget/custom_empty.dart';
import 'package:lead_plugin_epoint/widget/custom_line.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:lead_plugin_epoint/widget/custom_scaffold.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';
import 'package:lead_plugin_epoint/widget/widget.dart';


class ListDealScreen extends StatefulWidget {
  final DetailPotentialCustomerBloc bloc;

  const ListDealScreen({super.key, required this.bloc});

  @override
  ListDealScreenState createState() => ListDealScreenState();
}

class ListDealScreenState extends State<ListDealScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.bloc.getDetailLeadInfoDeal(context));
  }


  Widget _buildContainer(List<Widget> children){
    return CustomListView(
      padding: EdgeInsets.all(AppSizes.minPadding),
      separator: SizedBox(height: AppSizes.minPadding,),
      children: children,
    );
  }

  Widget _buildSkeleton() {
    return LoadingWidget(
        padding: EdgeInsets.zero,
        child: CustomListView(
          children: List.generate(
              10,
              (index) => CustomSkeleton(
                    height: 100,
                    radius: 4.0,
                  )),
        ));
  }

  Widget _buildContent() {
    return StreamBuilder(
      stream: widget.bloc.outputLeadInfoDeal,
      initialData: null,
      builder: (_, snapshot){
        List<DetailLeadInfoDealData>? models = snapshot.data as List<DetailLeadInfoDealData>?;
        return ContainerDataBuilder(
            data: models,
            skeletonBuilder: _buildSkeleton(),
            emptyBuilder: CustomEmpty(
              title: AppLocalizations.text(LangKey.data_empty),
            ),
            bodyBuilder: () => _buildContainer(
                models!
                    .map((e) => dealInfomationItem(
                  e,
                ))
                    .toList()));
      }
    );
  }

  Widget dealInfomationItem(DetailLeadInfoDealData item) {
    return InkWell(
      onTap: () async {
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        margin: EdgeInsets.only(left: 11, right: 11, bottom: 8.0),
        decoration: BoxDecoration(
            // color: Color.fromARGB(255, 37, 16, 16),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: Color(0xFFC3C8D3))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 5.0, right: 5.0, bottom: 5.0),
              margin: EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    height: 20.0,
                    width: 20.0,
                    child: Image.asset(Assets.iconDeal),
                  ),
                  Expanded(
                    child: Text(
                      item.dealName!,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500),
                      // maxLines: 1,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 4.0, right: 4.0),
                    height: 24,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                      child: Text(item.journeyName ?? "N/A",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600)),
                    ),
                  )
                ],
              ),
            ),
            _infoItemV2(
              Assets.iconTime,
              item.createdAt!,
            ),
            _infoItemV2(Assets.iconName, item.staffName ?? ""),
            _infoItemV2(Assets.iconInteraction, item.createdAt ?? ""),
            Container(
              padding: const EdgeInsets.only(left: 6.0, bottom: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    height: 15.0,
                    width: 15.0,
                    child: Image.asset(Assets.iconTag),
                  ),
                  Expanded(
                    child: Text(
                      "${NumberFormat("#,###", "vi-VN").format(item.amount ?? 0)} VNĐ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                      // maxLines: 1,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoItemV2(String icon, String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 13.0),
      margin: EdgeInsets.only(left: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            height: 15.0,
            width: 15.0,
            child: Image.asset(icon),
          ),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),
              // maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: AppLocalizations.text(LangKey.care_list),
      body: _buildContent(),
      onWillPop: () => CustomNavigator.pop(context, object: false),
    );
  }
}