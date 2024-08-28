import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/response/care_lead_response_model.dart';
import 'package:lead_plugin_epoint/model/response/contact_list_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/bloc/detail_potential_customer_bloc.dart';
import 'package:lead_plugin_epoint/widget/container_data_builder.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar_with_url.dart';
import 'package:lead_plugin_epoint/widget/custom_empty.dart';
import 'package:lead_plugin_epoint/widget/custom_line.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:lead_plugin_epoint/widget/custom_scaffold.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';
import 'package:lead_plugin_epoint/widget/widget.dart';


class ListContactScreen extends StatefulWidget {
  final DetailPotentialCustomerBloc bloc;

  const ListContactScreen({super.key, required this.bloc});

  @override
  ListContactScreenState createState() => ListContactScreenState();
}

class ListContactScreenState extends State<ListContactScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.bloc.getContactList(context));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.bloc.dispose();
    super.dispose();
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
      stream: widget.bloc.outputContactList,
      initialData: null,
      builder: (_, snapshot){
        List<ContactListData>? models = snapshot.data as List<ContactListData>?;
        return ContainerDataBuilder(
            data: models,
            skeletonBuilder: _buildSkeleton(),
            emptyBuilder: CustomEmpty(
              title: AppLocalizations.text(LangKey.data_empty),
            ),
            bodyBuilder: () => _buildContainer(
                models!
                    .map((e) => contactListItem(
                  e,
                ))
                    .toList()));
      }
    );
  }

  Widget contactListItem(ContactListData item) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Color(0xFFC3C8D3))),
      child: Column(
        children: [
          Row(
            children: [
              CustomAvatarWithURL(
                name: item!.fullName ?? "",
                size: 50.0,
              ),
              Container(
                width: 10.0,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.fullName ?? "",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                  (item.positon != null && item.positon != "")
                      ? Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Text(
                            item.positon ?? "",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0XFF8E8E8E),
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      : Container()
                ],
              )),
              (item.phone != null && item.phone != "")
                  ? InkWell(
                      onTap: () async {
                        print(item.phone ?? "");
                        await widget.bloc.callPhone(item?.phone ?? "");
                      },
                      child: Container(
                        padding: EdgeInsets.all(20.0 / 2),
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Color(0xFF06A605),
                          borderRadius: BorderRadius.circular(50),
                          // border:  Border.all(color: AppColors.white,)
                        ),
                        child: Center(
                            child: Image.asset(
                          Assets.iconCall,
                          color: AppColors.white,
                        )),
                      ),
                    )
                  : Container(),
            ],
          ),
          (item.phone != null && item.phone != "")
              ? Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                      ),
                      Text(
                        item.phone ?? "",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                )
              : Container(),
          (item.email != null && item.email != "")
              ? Container(
                  margin: EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                      ),
                      Text(
                        item.email ?? "",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                )
              : Container(),
          (item.address != null && item.address != "")
              ? Container(
                  margin: EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                      ),
                      Text(
                        item.address ?? "",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                )
              : Container()
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