import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/filter_screen_model.dart';
import 'package:lead_plugin_epoint/model/request/list_customer_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/model/response/list_customer_lead_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/create_potential_customer.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_potential_customer.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/detail_potential_customer.dart';
import 'package:lead_plugin_epoint/utils/global.dart';
import 'package:lead_plugin_epoint/utils/visibility_api_widget_name.dart';

import 'package:lead_plugin_epoint/widget/custom_avatar.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

class LeadScreen extends StatefulWidget {
  const LeadScreen({Key? key}) : super(key: key);

  @override
  State<LeadScreen> createState() => _LeadScreen();
}

class _LeadScreen extends State<LeadScreen> {
  ScrollController _controller = ScrollController();
  final TextEditingController _searchtext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();

  List<WorkListStaffModel> models = [];

  List<ListCustomLeadItems>? items;
  List<String> listFunction = [
    "CRM",
    "Dùng excel",
    "Chấm công",
    "Chathub",
    "Quản lý công việc",
    "Chấm công",
    "QLCV"
  ];

  int? currentPage = 1;
  int? nextPage = 2;

  ListCustomLeadModelRequest? filterModel = ListCustomLeadModelRequest(
    search: "",
    page: 1,
    statusAssign: "",
    customerType: "",
    tagId: [],
    customerSourceId: [],
    staffId: [],
    pipelineId: [],
    journeyId: [],
    careHistory: "",
    isConvert: "",
    createdAt: "",
    allocationDate: "",
  );

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
          fromDate_history_care_date: null,
          toDate_history_care_date: null,
          fromDate_work_schedule_date: null,
          toDate_work_schedule_date: null,
          id_history_care_date: "",
          id_work_schedule_date: "",
          id_created_at: "",
          id_allocation_date: "");
      getData(false);
    });
  }

  getData(bool loadMore, {int? page}) async {
    ListCustomLeadModelReponse? model = await LeadConnection.getList(
        context,
        ListCustomLeadModelRequest(
            search: _searchtext.text,
            page: filterModel!.page,
            statusAssign: filterModel!.statusAssign,
            customerType: filterModel!.customerType,
            staffId: filterModel!.staffId,
            tagId: filterModel!.tagId,
            customerSourceId: filterModel!.customerSourceId,
            isConvert: filterModel!.isConvert,
            createdAt: filterModel!.createdAt,
            allocationDate: filterModel!.allocationDate,
            careHistory:filterModel!.careHistory,
            pipelineId: filterModel!.pipelineId,
            journeyId: filterModel!.journeyId));

    if (model != null) {
      models = [];
      if (!loadMore) {
        items = [];
        items = model.data?.items;
        _controller.animateTo(
          _controller.position.minScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
        );
      } else {
        items!.addAll(model.data?.items as Iterable<ListCustomLeadItems> );
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
      if (this.currentPage! < this.nextPage!) {
        filterModel!.page = currentPage! + 1;
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
          AppLocalizations.text(LangKey.listPotential)!,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
          textAlign: TextAlign.start,
        ),
        // leadingWidth: 20.0,
        actions: [
          InkWell(
            onTap: () async {
              FilterScreenModel? result =
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FilterPotentialCustomer(
                            filterScreenModel: filterScreenModel,
                          )));

              if (result != null) {
                filterScreenModel = result;
                filterModel = result.filterModel;
                filterModel!.page = 1;
                getData(false);
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Image.asset(
                Assets.iconFilter,
                width: AppSizes.maxPadding,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: _buildBody(),
      floatingActionButton:checkVisibilityKey(VisibilityWidgetName.LE000001) ? FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () async {
          var result = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreatePotentialCustomer()));
          if (result != null) {
            var status = result["status"];
            if (status) {
              getData(false);
            }
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 50,
        ),
      ) : Container(),
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
              padding: EdgeInsets.only(
                  top: 30.0, bottom: 10.0, left: 10.0, right: 10.0),
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              // separator: const Divider(),
              children: [
                (items == null)
                    ? Container()
                    : (items!.length > 0)
                        ? Column(
                            children:
                                items!.map((e) => potentialItemV2(e)).toList())
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
                filterModel!.page = 1;
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
            filterModel!.page = 1;
            getData(false);
          }
          // },
          ),
    );
  }

  Widget potentialItemV2(ListCustomLeadItems item) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 32.0),
          // padding: EdgeInsets.only(bot),
          child: InkWell(
            onTap: () async {
              bool? result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailPotentialCustomer(
                        customer_lead_code: item.customerLeadCode,
                        indexTab: 0,
                        typeCustomer: item.customerType,
                      )));

              if (result != null && result) {
                getData(false);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: Color(0xFFC3C8D3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 8.0, top: 8.0),
                    margin: EdgeInsets.only(left: 107),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: item.customerSourceName ?? "",
                                style: TextStyle(
                                    height: 1.5,
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                                children: [
                              TextSpan(
                                  text: (item.customerSourceName != "" &&
                                          item.customerSourceName != null)
                                      ? (" - " + item.leadFullName!)
                                      : ("" + item.leadFullName!),
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              WidgetSpan(
                                  child: SizedBox(
                                width: 5.0,
                              )),
                              WidgetSpan(
                                  alignment: ui.PlaceholderAlignment.top,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 8.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF3AEDB6),
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Text(item.journeyName ?? "N/A",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 3, 68, 48),
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                  )),
                            ])),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(hidePhone(item.phone ?? "",checkVisibilityKey(VisibilityWidgetName.LE000002)),
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.normal)),

                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(right: 8.0, bottom: 8.0, top: 8.0),
                  margin: EdgeInsets.only(right: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              infoItem(Assets.iconName, item?.staffFullName ?? ""),
                              // infoItem(Assets.iconInteraction, "12/12/2022"),

                              Container(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 8.0),
                                margin: EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10.0),
                                      height: 15.0,
                                      width: 15.0,
                                      child: Image.asset(Assets.iconInteraction),
                                    ),
                                    (item.dateLastCare != null)
                                        ? Expanded(
                                            child: RichText(
                                                text: TextSpan(
                                                    text: item.dateLastCare! + " ",
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    children: [
                                                  TextSpan(
                                                      text:
                                                          "(${item.diffDay} ngày)",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.normal))
                                                ])),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              infoItem(Assets.iconChance, item?.pipelineName ?? ""),
                          ],
                        ),
                            )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            (checkVisibilityKey(VisibilityWidgetName.LE000002)) ? Container(
                              margin: EdgeInsets.only(bottom: 12.0),
                              child: InkWell(
                                onTap: () async {
                                  print(item.phone);
                                  await callPhone(item?.phone ?? "");
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
                              ),
                            ) : Container(
                              margin: EdgeInsets.only(bottom: 12.0),
                              height: 45,
                            ),

                            _actionItem(
                                    Assets.iconCall, Colors.green,
                                    colorIcon: Colors.white,
                                    number: 0,
                                    ontap: () async {
                                     if (Global.callHotline != null) {
                                      Global.callHotline!({
                                        "id": item.customerLeadId,
                                        "code": item.customerLeadCode,
                                        "avatar": item.avatar,
                                        "name": item.leadFullName,
                                        "phone": item.phone,
                                        "type": item.customerType,
                                      });
                                     }
                                  
                                }),

                            SizedBox(height: AppSizes.minPadding,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _actionItem(
                                    Assets.iconCalendar, Color(0xFF26A7AD),
                                    number: item?.relatedWork ?? 0,
                                    ontap: () async {
                                  bool? result = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              DetailPotentialCustomer(
                                                customer_lead_code:
                                                    item.customerLeadCode,
                                                indexTab: 2,
                                                typeCustomer:
                                                    item.customerType,
                                              )));

                                  if (result != null && result) {
                                    getData(false);
                                  }
                                  print("1");
                                }),
                                _actionItem(
                                    Assets.iconOutdate, Color(0xFFDD2C00),
                                    number: item?.appointment ?? 0,
                                    ontap: () async {
                                  bool? result = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              DetailPotentialCustomer(
                                                customer_lead_code:
                                                    item.customerLeadCode,
                                                typeCustomer:
                                                    item.customerType,
                                                indexTab: 2,
                                              )));

                                  if (result != null && result) {
                                    getData(false);
                                  }
                                  print("2");
                                }),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  item.tag!.length > 0
                      ? Container(
                          // width: AppSizes.maxWidth * 0.55,
                          padding: EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
                          child: Wrap(
                            children: List.generate(item.tag!.length,
                                (index) => _optionItem(item.tag![index])),
                            spacing: 10,
                            runSpacing: 10,
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: -22,
          child: _buildAvatar(item?.leadFullName ?? ""),
        ),
      ],
    );
  }

  Widget _actionItem(String icon, Color color, {required num number, GestureTapCallback? ontap, Color? colorIcon}) {
    return InkWell(
      onTap: ontap ,
      child: Container(
          margin: EdgeInsets.only(left: 14.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(1000.0)),
                child: Center(
                  child: Image.asset(

                    icon,
                    scale: 2.5,
                    color: colorIcon,
                  ),
                ),
              ),
              (number > 0)
                  ? Positioned(
                      left: 30,
                      bottom: 30,
                      child: Container(
                        width: (number > 99)
                            ? 30
                            : (number > 9)
                                ? 25
                                : 22,
                        height: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFF45E38)),
                        child: Center(
                            child: Text((number > 9) ? "9+" : "${number ?? 0}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600))),
                      ))
                  : Container()
            ],
          )),
    );
  }

  Widget statusPotential(String title, Color color, Color colorText) {
    return Container(
      margin: EdgeInsets.only(right: 8.0),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(title,
            style: TextStyle(
                color: colorText, fontSize: 14, fontWeight: FontWeight.normal)),
      ),
    );
  }

  Widget _optionItem(Tag item) {
    return Container(
      padding: EdgeInsets.only(left: 4.0, right: 4.0),
      height: 24,
      decoration: BoxDecoration(
          color: Color(0x420067AC), borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              height: 8.0,
              width: 8.0,
              margin: EdgeInsets.only(right: 5.0),
              decoration: BoxDecoration(
                  color: Color(0x790067AC),
                  borderRadius: BorderRadius.circular(1000.0))),
          Text(item.tagName!,
              style: TextStyle(
                  color: Color(0xFF0067AC),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
  }

  Widget infoItem(String icon, String title) {
    return Container(
      padding: const EdgeInsets.only(left: 8, bottom: 8.0),
      margin: EdgeInsets.only(bottom: 8.0),
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

  callPhone(String phone) async {
    await FlutterPhoneDirectCaller.callNumber(phone);
    // final regSpace = RegExp(r"\s+");
    // // return await launchUrl(Uri.parse("tel:" + phone.replaceAll(regSpace, "")));
    // return await launch("tel:" + phone.replaceAll(regSpace, ""));
  }

  Widget _buildAvatar(String name) {
    return Container(
      width: 87.0,
      height: 87.0,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: AppColors.primaryColor,
        ),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10000.0),
        child: CustomAvatar(
          color: Color(0xFFEEB132),
          name: name,
          textSize: 36.0,
        ),
      ),
    );
  }
}
