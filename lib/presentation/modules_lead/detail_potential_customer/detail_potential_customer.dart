import 'dart:math';
import 'package:draggable_expandable_fab/draggable_expandable_fab.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/response/contact_list_model_response.dart';
import 'package:lead_plugin_epoint/model/response/description_model_response.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/edit_potential_customer/edit_potential_customer.dart';
import 'package:lead_plugin_epoint/utils/global.dart';

import 'package:lead_plugin_epoint/widget/custom_avatar.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar_with_url.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPotentialCustomer extends StatefulWidget {
  final String customer_lead_code;
  final int indexTab;
  bool customerCare;
  DetailPotentialCustomer(
      {Key key, this.customer_lead_code, this.indexTab, this.customerCare})
      : super(key: key);

  @override
  _DetailPotentialCustomerState createState() =>
      _DetailPotentialCustomerState();
}

class _DetailPotentialCustomerState extends State<DetailPotentialCustomer> {
  final ScrollController _controller = ScrollController();
  List<WorkListStaffModel> models = [];
  List<ContactListData> contactListData;

  DetailPotentialData detail;
  bool allowPop = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getData();
    });
  }

  void getData() async {
    final moonLanding = DateTime.parse('2022-10-03 07:35:00');

    print(moonLanding.year);
    print(moonLanding.month);
    print(moonLanding.day);
    print(moonLanding.hour);
    print(moonLanding.minute);

    var dataDetail = await LeadConnection.getdetailPotential(
        context, widget.customer_lead_code);
    // var dataDetail = await LeadConnection.getdetailPotential( context, "LEAD_08112022190");
    if (dataDetail != null) {
      if (dataDetail.errorCode == 0) {
        detail = dataDetail.data;
        setState(() {});
      } else {
        await LeadConnection.showMyDialog(context, dataDetail.errorDescription);
        Navigator.of(context).pop();
      }
    }

    var contactList =
        await LeadConnection.getContactList(context, widget.customer_lead_code);
    // var dataDetail = await LeadConnection.getdetailPotential( context, "LEAD_08112022190");
    if (contactList != null) {
      if (contactList.errorCode == 0) {
        contactListData = contactList.data;
        setState(() {});
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
    return WillPopScope(
      onWillPop: () {
        if (widget.customerCare != null) {
          Navigator.of(context)
            // ..pop()
            ..pop(true);
        }

        if (allowPop) {
          Navigator.of(context).pop(allowPop);
        } else {
          Navigator.of(context).pop();
        }
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          // actionsIconTheme: Navigator.of(context).pop(true),
          backgroundColor: AppColors.primaryColor,
          title: Text(
            AppLocalizations.text(LangKey.detailPotential),
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
            decoration: BoxDecoration(color: AppColors.white),
            child: buildBody()),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: ExpandableDraggableFab(
          initialDraggableOffset:
              Offset(12, MediaQuery.of(context).size.height * 11 / 14),
          initialOpen: false,
          curveAnimation: Curves.easeOutSine,
          childrenBoxDecoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45),
              borderRadius: BorderRadius.circular(10.0)),
          childrenCount: 3,
          distance: 10,
          childrenType: ChildrenType.columnChildren,
          childrenAlignment: Alignment.centerRight,
          childrenInnerMargin: EdgeInsets.all(20.0),
          openWidget: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black.withOpacity(0.3),
                    )
                  ],
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 105, 136, 156)),
              width: 60,
              height: 60,
              child: Image.asset(
                Assets.iconFABMenu,
                scale: 2.5,
              )),
          closeWidget: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.3),
                )
              ], shape: BoxShape.circle, color: Color(0xFF5F5F5F)),
              width: 60,
              height: 60,
              child: Icon(
                Icons.clear,
                size: 35,
                color: Colors.white,
              )),
          children: [
            // (detail?.saleId == null || detail?.saleId == 0)
            //     ? Column(
            //         children: [
            //           FloatingActionButton(
            //               backgroundColor: AppColors.primaryColor,
            //               heroTag: "btn1",
            //               onPressed: () async {
            //                 models = await Navigator.of(context).push(
            //                     MaterialPageRoute(
            //                         // builder: (context) => AllocatorScreen()));
            //                         // builder: (context) => ListStaffModal()));
            //                         builder: (context) =>
            //                             PickOneStaffScreen(models: models,)));

            //                 if (models != null) {
            //                   DescriptionModelResponse result =
            //                       await LeadConnection.assignRevokeLead(
            //                           context,
            //                           AssignRevokeLeadRequestModel(
            //                               type: "assign",
            //                               customerLeadCode:
            //                                   detail.customerLeadCode,
            //                               saleId: models[0].staffId,
            //                               timeRevokeLead: 30));

            //                   if (result != null) {
            //                     if (result.errorCode == 0) {
            //                       print(result.errorDescription);
            //                       allowPop = true;

            //                       await LeadConnection.showMyDialog(
            //                           context, result.errorDescription);
            //                       getData();
            //                     } else {
            //                       LeadConnection.showMyDialog(
            //                           context, result.errorDescription);
            //                     }
            //                   }
            //                   setState(() {
            //                   }
            //                   );

            //                   print(models);
            //                 }

            //                 print("iconAssignment");
            //               },
            //               child:
            //                   Image.asset(Assets.iconAssignment, scale: 2.5)),
            //           SizedBox(
            //             height: 5.0,
            //           ),
            //           Text(
            //             AppLocalizations.text(LangKey.assignment),
            //             style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 14.0,
            //                 fontWeight: FontWeight.w400),
            //           )
            //         ],
            //       )
            //     : Column(
            //         children: [
            //           FloatingActionButton(
            //               backgroundColor: Color(0xFFFFAD02),
            //               heroTag: "btn1",
            //               onPressed: () async {
            //                 DescriptionModelResponse result =
            //                     await LeadConnection.assignRevokeLead(
            //                         context,
            //                         AssignRevokeLeadRequestModel(
            //                             type: "revoke",
            //                             customerLeadCode:
            //                                 detail.customerLeadCode,
            //                             saleId: detail.saleId,
            //                             timeRevokeLead: 30));

            //                 if (result != null) {
            //                   if (result.errorCode == 0) {
            //                     print(result.errorDescription);
            //                     allowPop = true;

            //                     await LeadConnection.showMyDialog(
            //                         context, result.errorDescription);
            //                     getData();
            //                   } else {
            //                     LeadConnection.showMyDialog(
            //                         context, result.errorDescription);
            //                   }
            //                 }

            //                 print("iconRecall");
            //               },
            //               child: Image.asset(Assets.iconRecall, scale: 2.5)),
            //           SizedBox(
            //             height: 5.0,
            //           ),
            //           Text(AppLocalizations.text(LangKey.recall),
            //               style: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 14.0,
            //                   fontWeight: FontWeight.w400))
            //         ],
            //       ),
            Column(
              children: [
                FloatingActionButton(
                    backgroundColor: Color(0xFFCD6000),
                    heroTag: "btn2",
                    onPressed: () async {
                      if (Global.createJob != null) {
                        await Global.createJob();
                      }

                      print("iconTask");
                    },
                    child: Image.asset(
                      Assets.iconTask,
                      scale: 2.5,
                    )),
                SizedBox(
                  height: 5.0,
                ),
                Text(AppLocalizations.text(LangKey.createJobs),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400))
              ],
            ),
            Column(
              children: [
                FloatingActionButton(
                    backgroundColor: Color(0xFFDD2C00),
                    heroTag: "btn3",
                    onPressed: () async {
                      LeadConnection.showMyDialogWithFunction(context,
                          AppLocalizations.text(LangKey.warningDeleteLead),
                          ontap: () async {
                        DescriptionModelResponse result =
                            await LeadConnection.deleteLead(
                                context, detail.customerLeadCode);

                        Navigator.of(context).pop();

                        if (result != null) {
                          if (result.errorCode == 0) {
                            allowPop = true;
                            print(result.errorDescription);

                            await LeadConnection.showMyDialog(
                                context, result.errorDescription);

                            Navigator.of(context).pop(true);
                          } else {
                            LeadConnection.showMyDialog(
                                context, result.errorDescription);
                          }
                        }
                      });
                      print("iconDelete");
                    },
                    child: Image.asset(
                      Assets.iconDelete,
                      scale: 2.5,
                    )),
                SizedBox(
                  height: 5.0,
                ),
                Text(AppLocalizations.text(LangKey.delete),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400))
              ],
            ),
            Column(
              children: [
                FloatingActionButton(
                  heroTag: "btn4",
                  onPressed: () async {
                    bool result =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditPotentialCustomer(
                                  detailPotential: detail,
                                )));

                    if (result != null) {
                      if (result) {
                        allowPop = true;
                        getData();
                        ;
                      }
                    }

                    print("iconEdit");
                  },
                  backgroundColor: Color(0xFF00BE85),
                  child: Image.asset(
                    Assets.iconEdit,
                    scale: 2.5,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(AppLocalizations.text(LangKey.edit),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return (detail == null)
        ? Container()
        : Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _controller,
                    children: buildInfomation(),
                  )),
                  Container(
                    height: 20.0,
                  )
                ],
              ),
              // Positioned(
              //     bottom: 30,
              //     left: 10,
              //     child: Column(
              //       children: [
              //         buildButtonConvert(
              //             AppLocalizations.text(LangKey.convertCustomers), () {
              //           print("chuyen doi khach hang");
              //         }),
              //         buildButtonConvert(
              //             AppLocalizations.text(
              //                 LangKey.convertCustomersWithDeal), () {
              //           print("chuyen doi khach hang co tao deal");
              //         }),
              //       ],
              //     ))
            ],
          );
  }

  List<Widget> buildInfomation() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.all(11.0),
              margin: EdgeInsets.only(top: 70),
              child: potentialInformationV2()),
          SubDetailPotentialCustomer(
            contactListData: contactListData,
            detail: detail,
            indexTab: widget.indexTab,
          )
        ],
      )
    ];
  }

  Widget potentialInformationV2() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          // margin: EdgeInsets.only(bottom: 32.0),
          // padding: EdgeInsets.only(bot),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Color(0xFFC3C8D3))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.only(right: 8.0, top: 8.0),
                    margin: EdgeInsets.only(top: 25.0),
                    child: Column(
                      children: [
                        // Container(
                        //   height: 24,
                        //   width: 55,
                        //   decoration: BoxDecoration(
                        //       color: Color(0xFF3AEDB6),
                        //       borderRadius: BorderRadius.circular(4.0)),
                        //   child: Center(
                        //     child: Text("Mới",
                        //         style: TextStyle(
                        //             color: Color(0xFF11B482),
                        //             fontSize: 14,
                        //             fontWeight: FontWeight.normal)),
                        //   ),
                        // ),
                        SizedBox(
                          height: 4.0,
                        ),
                        RichText(
                            text: TextSpan(
                                text: detail.customerSourceName ?? "",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                                children: [
                              TextSpan(
                                  text: (detail.customerSourceName != "" &&
                                          detail.customerSourceName != null)
                                      ? (" - " + detail?.fullName ?? "")
                                      : ("" + detail?.fullName ?? ""),
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ])),
                        SizedBox(height: 5),
                        Text(detail?.phone ?? "",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.normal)),
                        SizedBox(height: 5),
                        (detail.customerType == "business")
                            ? Text(
                                detail.fullName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    overflow: TextOverflow.visible,
                                    fontSize: 16.0,
                                    color: Color(0xFF8E8E8E),
                                    fontWeight: FontWeight.normal),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 8.0),
                  margin: EdgeInsets.only(right: 8.0, top: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          // width: MediaQuery.of(context).size.width / 2 - 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // infoItem(Assets.iconName, item?.staffFullName ?? "", true),
                              // infoItem(Assets.iconInteraction, item?.journeyName ?? "", true),

                              infoItem(Assets.iconName, detail.saleName ?? ""),
                              infoItem(Assets.iconInteraction, detail.dateLastCare ?? ""),

                              // Container(
                              //   height: 24,
                              //   width: 55,
                              //   margin: EdgeInsets.only(left: 8.0),
                              //   decoration: BoxDecoration(
                              //       color: Color(0xFF3AEDB6),
                              //       borderRadius: BorderRadius.circular(4.0)),
                              //   child: Center(
                              //     child: Text("Mới",
                              //         style: TextStyle(
                              //             color: Color(0xFF11B482),
                              //             fontSize: 14,
                              //             fontWeight: FontWeight.normal)),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              print(detail.phone);
                              await callPhone(detail?.phone ?? "");
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
                          SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _actionItem(
                                  Assets.iconCalendar, Color(0xFF26A7AD),
                                  show: true,
                                  number: detail.relatedWork ?? 0, ontap: () {
                                print("1");
                              }),
                              _actionItem(Assets.iconOutdate, Color(0xFFDD2C00),
                                  show: true,
                                  number: detail.appointment ?? 0, ontap: () {
                                print("2");
                              }),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 14.0),
                (detail.tag != null && detail.tag.length > 0)
                    ? Container(
                        padding: EdgeInsets.only(bottom: 8.0),
                        margin: EdgeInsets.only(left: 8.0),
                        child: Wrap(
                          children: List.generate(detail.tag.length,
                              (index) => _optionItem(detail.tag[index])),
                          spacing: 10,
                          runSpacing: 10,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 60.5,
          top: -60,
          child: _buildAvatar(detail?.fullName ?? ""),
        ),
      ],
    );
  }

  Widget infoItem(String icon, String title) {
    return Container(
      padding: const EdgeInsets.only(left: 8, bottom: 8.0),
      margin: EdgeInsets.only(bottom: 4.0),
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

  Widget _actionItem(String icon, Color color,
      {num number, bool show = false, Function ontap}) {
    return InkWell(
      onTap: ontap,
      child: Container(
          margin: EdgeInsets.only(left: 17),
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
                  ),
                ),
              ),
              show
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
                            child: Text("${number ?? 0}",
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
          Text(item.tagName,
              style: TextStyle(
                  color: Color(0xFF0067AC),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
  }

  Widget _infoItem(String title, String content,
      {TextStyle style, String icon, String icon2}) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      margin: EdgeInsets.only(left: 15.0 / 2),
      child: Row(
        children: [
          Container(
            width: (MediaQuery.of(context).size.width) / 1.9,
            child: Row(
              children: [
                if (icon != null)
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    height: 15.0,
                    width: 15.0,
                    child: Image.asset(icon),
                  ),
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    title,
                    style: AppTextStyles.style15BlackNormal,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Text(
            content,
            style: style ?? AppTextStyles.style15BlackNormal,
            // maxLines: 1,
          )),
          if (icon2 != null)
            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              height: 30.0,
              width: 30.0,
              child: Image.asset(icon2),
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

  Widget buildButtonConvert(String title, Function ontap) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      height: 41,
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: ontap,
        child: Center(
          child: Text(
            // AppLocalizations.text(LangKey.convertCustomers),
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w700),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class DetailPotentialTabModel {
  String typeName;
  int typeID;
  bool selected;

  DetailPotentialTabModel({this.typeName, this.typeID, this.selected});

  factory DetailPotentialTabModel.fromJson(Map<String, dynamic> parsedJson) {
    return DetailPotentialTabModel(
        typeName: parsedJson['typeName'],
        typeID: parsedJson['typeID'],
        selected: parsedJson['selected']);
  }
}

class SubDetailPotentialCustomer extends StatefulWidget {
  DetailPotentialData detail;
  List<ContactListData> contactListData;

  final int indexTab;
  SubDetailPotentialCustomer(
      {Key key, this.detail, this.indexTab, this.contactListData})
      : super(key: key);

  @override
  _SubDetailPotentialCustomerState createState() =>
      _SubDetailPotentialCustomerState();
}

class _SubDetailPotentialCustomerState
    extends State<SubDetailPotentialCustomer> {
  int index = 0;
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    decimalDigits: 0,
    symbol: '',
  );

  List<DetailPotentialTabModel> tabPotentials = [
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.generalInfomation),
        typeID: 0,
        selected: true),
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.deal),
        typeID: 1,
        selected: false),
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.customerCare),
        typeID: 2,
        selected: false),
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.discuss),
        typeID: 3,
        selected: false),
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.contactPerson),
        typeID: 4,
        selected: false)
  ];

  @override
  void initState() {
    super.initState();
    index = widget.indexTab;
    for (int i = 0; i < tabPotentials.length; i++) {
      if (index == tabPotentials[i].typeID) {
        tabPotentials[i].selected = true;
      } else {
        tabPotentials[i].selected = false;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: buildListOption(),
        ),
        Container(
          height: 15,
        ),
        (index == 0)
            ? generalInfomationV2()
            : (index == 1)
                ? dealInfomationV2()
                : (index == 2)
                    ? customerCare()
                    : (index == 3)
                        ? Container()
                        : contactList()
      ],
    );
  }

  Widget buildListOption() {
    return Row(
      children: [
        option(tabPotentials[0].typeName, tabPotentials[0].selected, 100, () {
          index = 0;
          selectedTab(0);
        }),
        option(tabPotentials[1].typeName, tabPotentials[1].selected, 100, () {
          index = 1;
          selectedTab(1);
        }),
        option(tabPotentials[2].typeName, tabPotentials[2].selected, 150, () {
          index = 2;
          selectedTab(2);
        }),
        option(tabPotentials[3].typeName, tabPotentials[3].selected, 60, () {
          index = 3;
          selectedTab(3);
        }),
        option(tabPotentials[4].typeName, tabPotentials[4].selected, 100, () {
          index = 4;
          selectedTab(4);
        })
      ],
    );
  }

  Widget option(String title, bool show, double width, Function ontap) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15.0 / 1.5),
          height: 40,
          child: InkWell(
            onTap: ontap,
            child: Center(
              child: Text(
                title,
                style: show
                    ? TextStyle(
                        fontSize: AppTextSizes.size16,
                        color: AppColors.blueColor,
                        fontWeight: FontWeight.bold)
                    : TextStyle(
                        fontSize: AppTextSizes.size16,
                        color: AppColors.colorTabUnselected,
                        fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ),
        ),
        show
            ? Container(
                decoration: const BoxDecoration(color: AppColors.blueColor),
                width: width,
                height: 3.0,
              )
            : Container()
      ],
    );
  }

  Widget generalInfomationV2() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: EdgeInsets.only(left: 11, right: 11, bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Color(0xFFC3C8D3))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _infoItemV2(
                    Assets.iconSex,
                    (widget.detail.gender == "male")
                        ? AppLocalizations.text(LangKey.male)
                        : (widget.detail.gender == "female")
                            ? AppLocalizations.text(LangKey.female)
                            : (widget.detail.gender == "other" ||
                                    widget.detail.gender == "other")
                                ? AppLocalizations.text(LangKey.other)
                                : ""),
                SizedBox(height: 5.0),
                _infoItemV2(Assets.iconEmail, widget.detail.email ?? ""),
                SizedBox(height: 5.0),
                _infoItemV2(Assets.iconAddress, widget.detail.address ?? ""),
                SizedBox(height: 5.0),
                _infoItemV2(
                    Assets.iconWards, widget.detail.businessClueName ?? "")
              ],
            ),
          ),
          Column(
            children: [
              (widget.detail.zalo != null && widget.detail.zalo != "")
                  ? InkWell(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                        height: 45.0,
                        width: 45.0,
                        child: Image.asset(Assets.iconMessenger),
                      ),
                    )
                  : Container(),
              (widget.detail.fanpage != null && widget.detail.fanpage != "")
                  ? InkWell(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                        height: 57.0,
                        width: 57.0,
                        child: Image.asset(Assets.iconZalo),
                      ),
                    )
                  : Container()
            ],
          )
        ],
      ),
    );
  }

  Widget dealInfomationV2() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child:
          (widget.detail.infoDeal != null && widget.detail.infoDeal.length > 0)
              ? Column(
                  children: widget.detail.infoDeal
                      .map((e) => dealInfomationItem(e))
                      .toList())
              : CustomDataNotFound(),
    );
  }

  Widget dealInfomationItem(InfoDeal item) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      margin: EdgeInsets.only(left: 11, right: 11, bottom: 8.0),
      decoration: BoxDecoration(
          color: Colors.white,
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
                    item.dealName,
                    // "Deal cua Kiet Quach",
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
                    child: Text("Mới - 80%",
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
            item.createdAt,
          ),
          _infoItemV2(Assets.iconName, "Linh gard"),
          _infoItemV2(Assets.iconInteraction, item.dateLastCare ?? ""),
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
                    "${NumberFormat("#,###", "vi-VN").format(item.amount)} VNĐ",
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
    );
  }

  Widget customerCare() {
    // return Container(
    //   margin: EdgeInsets.only(bottom: 120.0),
    //   child: Column(
    //     children: [customerCareItem(), customerCareItem(), customerCareItem()],
    //   ),
    // );

    // return Container(
    //   margin: EdgeInsets.only(bottom: 120),
    //   child: (widget.detail.careHistory != null && widget.detail.careHistory.length > 0 )
    //                     ? Column(
    //                         children:
    //                             widget.detail.careHistory.map((e) => customerCareItem(e)).toList())
    //                     : CustomDataNotFound(),
    // );

    return Column(
      children: [
        customerCareItem(),
        customerCareItem(),
        customerCareItem(),
        Container(
          height: 20.0,
        )
      ],
    );
  }

  // Widget customerCareHistory() {
  // return Container(
  //   margin: EdgeInsets.only(bottom: 120),
  //   child: (widget.detail.customerCare != null && widget.detail.customerCare.length > 0 )
  //                     ? Column(
  //                         children:
  //                             widget.detail.careHistory.map((e) => customerCareItem(e)).toList())
  //                     : CustomDataNotFound(
  //                     ),
  // );
  // }

  // Widget customerCareItem(CareHistory item) {

  Widget customerCareItem() {
    return InkWell(
      onTap: () async {},
      child: Container(
        child: Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          // height: 300,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Container(
                child: SizedBox(
                  //Cái này là bên trái
                  width: MediaQuery.of(context).size.width / 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        '09:45',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '22,\ntháng 12,\nnăm 2022',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                //Cai này là bên phải
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 10.0),
                  decoration: BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Cái này là dòng tiêu đề
                      Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text:
                                      '[012345678] Tên công việc này dài quá trời dài',
                                  style: TextStyle(
                                    color: Color(0xFF0067AC),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: ' ',
                                    ),
                                    WidgetSpan(
                                        child: Icon(
                                      Icons.check_circle_outline_sharp,
                                      color: Colors.green,
                                      size: 16,
                                    )),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      InkWell(
                        child: Container(
                          height: 30,
                          width: 100,
                          margin: EdgeInsets.only(top: 10.0),
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black.withOpacity(0.3),
                            )
                          ], color: Colors.white),
                          child: Row(
                            children: [
                              Image.asset(
                                Assets.iconCall,
                                scale: 3.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                AppLocalizations.text(LangKey.call),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500),
                                // maxLines: 1,
                              )
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "15",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                  // maxLines: 1,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Image.asset(
                                  Assets.iconFiles,
                                  scale: 3.0,
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  "12",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                  // maxLines: 1,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Image.asset(
                                  Assets.iconComment,
                                  scale: 3.0,
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  "12",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                  // maxLines: 1,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Image.asset(
                                  Assets.iconTimeDetail,
                                  scale: 3.0,
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            CustomAvatarWithURL(
                              name: "NV.Trixie Miami",
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
                                  "NV.Trixie Miami",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),

                      Container(
                        child: Wrap(
                          children: List.generate(5, (index) => _tagItem()),
                          spacing: 10,
                          runSpacing: 10,
                        ),
                      )

                      //cái này là button gọi điện
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tagItem() {
    return Container(
      height: 30,
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          color: Colors.black.withOpacity(0.3),
        )
      ], color: Colors.white),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.iconTag,
            scale: 3.0,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            "Tag1",
            textAlign: TextAlign.start,
            style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500),
            // maxLines: 1,
          )
        ],
      ),
    );
  }

  Widget customerCareInfoItem(String title) {
    return Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: Color(0xFFC3C8D3))),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 8.0),
                RichText(
                    text: TextSpan(
                        text: "Loại công việc: ",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: "Gọi điện",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal))
                    ])),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Container(
                    //   height: 16,
                    //   width: 16,
                    //   margin: EdgeInsets.only(right: 5.0),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(1000.0),
                    //       color: Colors.orange),
                    // ),

                    _buildAvatarWithImage(
                        "https://i.ex-cdn.com/mgn.vn/files/content/2022/11/10/sofm-101-1240.jpg"),

                    SizedBox(width: 5.0),

                    Text(
                      "NV.Trixie Miami",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                )
              ],
            )),
            Container(
              padding: EdgeInsets.only(left: 6.0, right: 6.0),
              height: 24,
              decoration: BoxDecoration(
                  color: Color(0xFF068229),
                  borderRadius: BorderRadius.circular(525.0)),
              child: Center(
                child: Text("Đã hoàn thành",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600)),
              ),
            )
          ],
        ));
  }

  Widget contactList() {
    return Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(bottom: 20),
        child: (widget.contactListData != null &&
                widget.contactListData.length > 0)
            ? Column(
                children: widget.contactListData
                    .map((e) => contactListItem(e))
                    .toList())
            : CustomDataNotFound());
  }

  Widget contactListItem(ContactListData item) {
    return (widget.contactListData != null && widget.contactListData.length > 0) ? Container(
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
                name: item.fullName ?? "",
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
    ) : CustomDataNotFound();
  }

  Future<bool> callPhone(String phone) async {
    final regSpace = RegExp(r"\s+");
    // return await launchUrl(Uri.parse("tel:" + phone.replaceAll(regSpace, "")));
    return await launch("tel:" + phone.replaceAll(regSpace, ""));
  }

  Widget _buildAvatarWithImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10000.0),
      child: FittedBox(
        child: Container(
          width: 16.0,
          height: 16.0,
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(1), BlendMode.dstATop),
                  image: NetworkImage(image))),
        ),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _infoItemV2(String icon, String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8.0),
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

  // Widget generalInfomation() {
  //   return Container(
  //     padding: const EdgeInsets.all(8.0),
  //     margin: EdgeInsets.only(bottom: 20.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(8),
  //           child: Text(
  //             AppLocalizations.text(LangKey.picture),
  //             style: TextStyle(
  //                 fontSize: AppTextSizes.size15,
  //                 color: const Color(0xFF858080),
  //                 fontWeight: FontWeight.normal),
  //           ),
  //         ),

  //         Center(
  //           child: (widget.detail.avatar == "")
  //               ? _buildAvatarImg(widget.detail.fullName)
  //               : _buildAvatarWithImage(widget.detail.avatar),
  //         ),

  //         const Divider(),

  //         _infoItem(
  //             AppLocalizations.text(LangKey.email), widget.detail?.email ?? "",
  //             icon: Assets.iconEmail),
  //         const Divider(),
  //         sexInfo(widget.detail?.gender ?? ""),
  //         const Divider(),
  //         _infoItem(AppLocalizations.text(LangKey.provinceCity),
  //             "${widget.detail?.provinceType ?? ""} ${widget.detail?.provinceName ?? ""}",
  //             icon: Assets.iconProvince),
  //         const Divider(),
  //         _infoItem(AppLocalizations.text(LangKey.district),
  //             "${widget.detail?.districtType ?? ""} ${widget.detail?.districtName ?? ""}",
  //             icon: Assets.iconDistrict),
  //         const Divider(),
  //         // _infoItem(AppLocalizations.text(LangKey.wards),
  //         //     "${widget.detail?.wardType ?? ""} ${widget.detail?.wardName ?? ""}",
  //         //     icon: Assets.iconWards),
  //         // const Divider(),
  //         _infoItem(AppLocalizations.text(LangKey.address),
  //             widget.detail?.address ?? "",
  //             icon: Assets.iconAddress),
  //         const Divider(),
  //         _infoItem(AppLocalizations.text(LangKey.businessFocalPoint),
  //             widget.detail?.businessClue ?? "",
  //             icon: Assets.iconPoint),
  //         const Divider(),
  //         _channelItem(
  //             AppLocalizations.text(LangKey.zalo), widget.detail?.zalo ?? "",
  //             icon: Assets.iconSource,
  //             icon2: Assets.iconZalo,
  //             style: TextStyle(
  //                 fontSize: AppTextSizes.size16,
  //                 color: AppColors.bluePrimary,
  //                 fontWeight: FontWeight.w500), ontap: () {
  //           _openChathub(widget.detail?.zalo ?? "");
  //         }),
  //         const Divider(),
  //         _channelItem(AppLocalizations.text(LangKey.fanpage),
  //             widget.detail?.fanpage ?? "",
  //             icon: Assets.iconFanpage,
  //             icon2: Assets.iconMessenger,
  //             style: TextStyle(
  //                 fontSize: AppTextSizes.size16,
  //                 color: AppColors.bluePrimary,
  //                 fontWeight: FontWeight.w500), ontap: () {
  //           _openChathub(widget.detail?.fanpage ?? "");
  //         })
  //       ],
  //     ),
  //   );
  // }

  // Widget _infoItem(String title, String content,
  //     {TextStyle style, String icon, String icon2}) {
  //   return Container(
  //     padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
  //     margin: EdgeInsets.only(left: 15.0 / 2),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: (MediaQuery.of(context).size.width) / 1.9,
  //           child: Row(
  //             children: [
  //               if (icon != null)
  //                 Container(
  //                   margin: const EdgeInsets.only(right: 8.0),
  //                   height: 15.0,
  //                   width: 15.0,
  //                   child: Image.asset(icon),
  //                 ),
  //               Container(
  //                 margin: const EdgeInsets.only(right: 8.0),
  //                 child: Text(
  //                   title,
  //                   style: AppTextStyles.style15BlackNormal,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //             child: Text(
  //           content,
  //           style: style ?? AppTextStyles.style15BlackNormal,
  //           // maxLines: 1,
  //         )),
  //         if (icon2 != null)
  //           Container(
  //             margin: const EdgeInsets.only(left: 8.0, right: 8.0),
  //             height: 30.0,
  //             width: 30.0,
  //             child: Image.asset(icon2),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _channelItem(String title, String content,
  //     {TextStyle style, String icon, String icon2, Function ontap}) {
  //   return Container(
  //     padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
  //     margin: EdgeInsets.only(left: 15.0 / 2),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: (MediaQuery.of(context).size.width) / 1.9,
  //           child: Row(
  //             children: [
  //               if (icon != null)
  //                 Container(
  //                   margin: const EdgeInsets.only(right: 8.0),
  //                   height: 15.0,
  //                   width: 15.0,
  //                   child: Image.asset(icon),
  //                 ),
  //               Container(
  //                 margin: const EdgeInsets.only(right: 8.0),
  //                 child: Text(
  //                   title,
  //                   style: AppTextStyles.style15BlackNormal,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //             child: InkWell(
  //           onTap: ontap,
  //           child: Text(
  //             content,
  //             style: style ?? AppTextStyles.style15BlackNormal,
  //             // maxLines: 1,
  //           ),
  //         )),
  //         if (icon2 != null)
  //           Container(
  //             margin: const EdgeInsets.only(left: 8.0, right: 8.0),
  //             height: 30.0,
  //             width: 30.0,
  //             child: Image.asset(icon2),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Future _openChathub(String link) async {
    return await launch(link);
  }

  Widget featureDeveloping() {
    return Container(
      margin: EdgeInsets.only(top: 50.0, bottom: 100.0),
      child: Column(
        children: [
          SizedBox(
            height: 204,
            width: 295,
            child: Image.asset(Assets.imgFeatureDeveloping),
          ),
          Center(
              child: Text(
            AppLocalizations.text(LangKey.featureDeveloping),
            style: AppTextStyles.style18BlueBold,
            maxLines: 1,
          ))
        ],
      ),
    );
  }

  Widget sexInfo(String sex) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      margin: EdgeInsets.only(left: 15.0 / 2),
      child: Row(
        children: [
          Container(
            width: (MediaQuery.of(context).size.width) / 2,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  height: 20.0,
                  width: 20.0,
                  child: Image.asset(Assets.iconSex),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    AppLocalizations.text(LangKey.sex),
                    style: AppTextStyles.style15BlackNormal,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          sex != ""
              ? Container(
                  height: 40,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: AppColors.darkGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      sex != "other"
                          ? Container(
                              margin: const EdgeInsets.only(
                                right: 4.0,
                              ),
                              height: 20.0,
                              width: 20.0,
                              child: sex == "male"
                                  ? Image.asset(Assets.iconMale)
                                  : Image.asset(Assets.iconFemale),
                            )
                          : Container(),
                      Text(
                        sex == "other"
                            ? AppLocalizations.text(LangKey.other)
                            : sex == "male"
                                ? AppLocalizations.text(LangKey.male)
                                : AppLocalizations.text(LangKey.female),
                        style: AppTextStyles.style15BlackNormal,
                        maxLines: 1,
                      )
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  // Widget _buildAvatarImg(String name) {
  //   return Container(
  //     width: 65.0,
  //     height: 65.0,
  //     padding: const EdgeInsets.all(2.0),
  //     decoration: const BoxDecoration(
  //       shape: BoxShape.circle,
  //       color: AppColors.lightGrey,
  //     ),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(10000.0),
  //       child: CustomAvatar(
  //         name: name,
  //         textSize: AppTextSizes.size22,
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildAvatarWithImage(String image) {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(10000.0),
  //     child: FittedBox(
  //       child: Container(
  //         width: 80.0,
  //         height: 80.0,
  //         padding: const EdgeInsets.all(2.0),
  //         decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: Colors.blueGrey,
  //             image: DecorationImage(
  //                 fit: BoxFit.cover,
  //                 colorFilter: ColorFilter.mode(
  //                     Colors.black.withOpacity(1), BlendMode.dstATop),
  //                 image: NetworkImage(image))),
  //       ),
  //       fit: BoxFit.fill,
  //     ),
  //   );
  // }

  selectedTab(int index) async {
    List<DetailPotentialTabModel> models = tabPotentials;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;

    setState(() {});
  }
}
