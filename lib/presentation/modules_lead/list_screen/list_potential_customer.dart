import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/filter_screen_model.dart';
import 'package:lead_plugin_epoint/model/object_pop_detail_model.dart';
import 'package:lead_plugin_epoint/model/request/list_customer_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/list_customer_lead_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/create_potential_customer.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_potential_customer.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/detail_potential_customer.dart';

import 'package:lead_plugin_epoint/widget/custom_avatar.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({Key key}) : super(key: key);

  @override
  State<LeadScreen> createState() => _LeadScreen();
}

class _LeadScreen extends State<LeadScreen> {
  ScrollController _controller = ScrollController();
  final TextEditingController _searchtext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();
  List<ListCustomLeadItems> items ;

  int currentPage = 1;
  int nextPage = 2;

  ListCustomLeadModelRequest filterModel = ListCustomLeadModelRequest(
      search: "",
      page: 1,
      statusAssign: "",
      customerType: "",
      tagId: "",
      customerSourceName: "",
      isConvert: "",
      staffFullName: "",
      pipelineName: "",
      journeyName: "",
      createdAt: "",
      allocationDate: "");

  FilterScreenModel filterScreenModel = FilterScreenModel();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      filterScreenModel = FilterScreenModel(
          filterModel: filterModel,
          fromDate_allocation_date: null,
          toDate_allocation_date: null,
          fromDate_created_at: null,
          toDate_created_at: null,
          id_created_at: "",
          id_allocation_date: "");
      getData(false);
    });
  }

  getData(bool loadMore, {int page}) async {
    ListCustomLeadModelReponse model = await LeadConnection.getList(
        context,
        ListCustomLeadModelRequest(
            search: _searchtext.text,
            page: filterModel.page,
            statusAssign: filterModel.statusAssign,
            customerType: filterModel.customerType,
            tagId: filterModel.tagId,
            customerSourceName: filterModel.customerSourceName,
            isConvert: filterModel.isConvert,
            staffFullName: filterModel.staffFullName,
            pipelineName: filterModel.pipelineName,
            journeyName: filterModel.journeyName,
            createdAt: filterModel.createdAt,
            allocationDate: filterModel.allocationDate));
    if (model != null) {
      if (!loadMore) {
        items = [];
        items = model.data?.items;
        _controller.animateTo(
          _controller.position.minScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
        );
      } else {
        items.addAll(model.data?.items);
      }
      currentPage = model.data?.pageInfo?.currentPage;
      nextPage = model.data?.pageInfo?.nextPage;
      setState(() {});
    } else {
      items = [];
      setState(() {});
    }
  }

  _scrollListener() async {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (this.currentPage < this.nextPage) {
        filterModel.page = currentPage + 1;
        getData(true);
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: AppColors.primaryColor,
        title: Text(
          AppLocalizations.text(LangKey.listPotential),
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        // leadingWidth: 20.0,
        actions: [
          InkWell(
            onTap: () async {
              FilterScreenModel result =
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FilterPotentialCustomer(
                            filterScreenModel: filterScreenModel,
                          )));

              if (result != null) {
                filterScreenModel = result;
                filterModel = result.filterModel;
                filterModel.page = 1;
                getData(false);
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Image.asset(
                Assets.iconFilter,
                width: 24.0,
              ),
            ),
          )
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ObjectPopDetailModel result = await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => CreatePotentialCustomer()));
          if (result != null) {
            if (result.status) {
              getData(false);
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Column(
        children: [
          _buildSearch(),
          Expanded(
            child: CustomListView(
              padding: EdgeInsets.all(20.0 / 2),
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              // separator: const Divider(),
              children: [
                (items == null)
                    ? Container()
                    : (items.length > 0)
                        ? Column(
                            children:
                                items.map((e) => potentialItem(e)).toList())
                        : CustomDataNotFound(),
                Container(height: 100)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextField(
          enabled: true,
          controller: _searchtext,
          focusNode: _fonusNode,
          // focusNode: _focusNode,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.all(12.0),
            border: OutlineInputBorder(
              // borderSide:
              //     BorderSide(width: 1, color: Color.fromARGB(255, 21, 230, 129)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xFFB8BFC9)),
            ),
            hintText: AppLocalizations.text(LangKey.filterNameCodePhone),
            suffixIcon: InkWell(
              splashColor: Colors.white,
              onTap: () async {
                filterModel.page = 1;
                getData(false);
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset(
                  Assets.iconSearch,
                ),
              ),
            ),
            suffixIconConstraints:
                BoxConstraints(maxHeight: 40.0, maxWidth: 40.0),
            isDense: true,
          ),
          onChanged: (event) {
            // print(event.toLowerCase());
            if (_searchtext != null) {
              // print(_searchext.text);

            }
          },
          onSubmitted: (event) async {
            filterModel.page = 1;
            getData(false);
          }
          // },
          ),
    );
  }

  Widget potentialItem(ListCustomLeadItems item) {
    return Stack(
      children: [
        InkWell(
          onTap: () async {
            bool result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailPotentialCustomer(
                      customer_lead_code: item.customerLeadCode,
                    )));

            if (result != null && result) {
              getData(false);
            }
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
                color: Color(0xFFF6F6F7),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Color(0xFFC3C8D3))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  margin: EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (item.isConvert == 0)
                            ? MediaQuery.of(context).size.width / 2 - 20
                            : MediaQuery.of(context).size.width / 2 + 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAvatar(item?.leadFullName ?? ""),
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoSizeText(
                                      item?.leadFullName ?? "",
                                      style: TextStyle(
                                          fontSize: AppTextSizes.size14,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600),
                                      // maxLines: ,
                                    ),
                                    Text(
                                      item?.tagName ?? "",
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      // maxLines: 1,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      (item.isConvert == 0)
                          ? Container(
                              padding: EdgeInsets.all(15.0 / 1.5),
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Color(0xFF11B482),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                child: Text(
                                  AppLocalizations.text(
                                      LangKey.convertCustomersSuccess),
                                  style: AppTextStyles.style14WhiteWeight400,
                                ),
                              ),
                            )
                          : Expanded(
                              child: Container(
                                padding: EdgeInsets.all(15.0 / 1.5),
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Color(0xFF8E8E8E),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.text(
                                        LangKey.convertCustomersNotSuccess),
                                    style: AppTextStyles.style14WhiteWeight400,
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
                infoItem(Assets.iconCall, item?.phone ?? "", false),
                infoItem(
                    Assets.iconChance,
                    "${item?.pipelineName ?? ""} - ${item?.journeyName ?? ""}",
                    false),
                infoItem(
                    Assets.iconPerson, item?.customerSourceName ?? "", false),
                infoItem(Assets.iconName, item?.staffFullName ?? "", true),
              ],
            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 20,
          child: InkWell(
            onTap: () async {
              print(item.phone);
              await callPhone(item?.phone ?? "");
            },
            child: Container(
              padding: EdgeInsets.all(20.0 / 2),
              height: 50,
              width: 50,
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
          ),
        ),
      ],
    );
  }

  Widget infoItem(String icon, String title, bool minWidth) {
    return Container(
      width: minWidth
          ? MediaQuery.of(context).size.width - 80
          : MediaQuery.of(context).size.width - 40,
      // height: 40,
      padding: const EdgeInsets.only(left: 8, bottom: 8.0),
      margin: EdgeInsets.only(left: 15.0 / 2, bottom: 8.0),
      child: Row(
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
              style: AppTextStyles.style14BlackWeight500,
              // maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> callPhone(String phone) async {
    final regSpace = RegExp(r"\s+");
    // return await launchUrl(Uri.parse("tel:" + phone.replaceAll(regSpace, "")));
    return await launch("tel:" + phone.replaceAll(regSpace, ""));
  }

  Widget _buildAvatar(String name) {
    return Container(
      width: 50.0,
      height: 50.0,
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightGrey,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10000.0),
        child: CustomAvatar(
          name: name,
          textSize: AppTextSizes.size22,
        ),
      ),
    );
  }
}
