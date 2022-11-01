import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/object_pop_detail_model.dart';
import 'package:lead_plugin_epoint/model/request/assign_revoke_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/description_model_response.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/edit_potential_customer/edit_potential_customer.dart';

import 'package:lead_plugin_epoint/widget/custom_avatar.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPotentialCustomer extends StatefulWidget {
  final String customer_lead_code;
  const DetailPotentialCustomer({Key key, this.customer_lead_code})
      : super(key: key);

  @override
  _DetailPotentialCustomerState createState() =>
      _DetailPotentialCustomerState();
}

class _DetailPotentialCustomerState extends State<DetailPotentialCustomer> {
  final ScrollController _controller = ScrollController();
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
    var dataDetail = await LeadConnection.getdetailPotential(
        context, widget.customer_lead_code);
    if (dataDetail != null) {
      detail = dataDetail.data;
      setState(() {});
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
        if(allowPop){
              Navigator.of(context).pop( allowPop);
        }
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          // actionsIconTheme: Navigator.of(context).pop(true),
          backgroundColor: AppColors.primaryColor,
          title: Text(
            AppLocalizations.text(LangKey.detailPotential),
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          leadingWidth: 20.0,
        ),
        body: Container(
            decoration: const BoxDecoration(color: AppColors.white),
            child: buildBody()),
      ),
    );
  }

  Widget buildBody() {
    return (detail == null)
        ? Container()
        : Column(
            children: [
              Container(
                  // height: 100,
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFunction(
                          AppLocalizations.text(LangKey.edit),
                          Assets.iconEdit,
                          Color.fromARGB(255, 89, 177, 150), () async {
                        bool result = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditPotentialCustomer(
                              detailPotential: detail,
                            )));

                        if (result != null) {
                          if (result) {
                            allowPop = true;
                            getData();
                            ;
                          }
                        }
                      }),
                      _buildFunction(
                          AppLocalizations.text(LangKey.delete),
                          Assets.iconDelete,
                          Color.fromARGB(255, 231, 86, 86), () async {
                        DescriptionModelResponse result =
                            await LeadConnection.deleteLead(
                                context, detail.customerLeadCode);

                        if (result != null) {
                          if (result.errorCode == 0) {
                            print(result.errorDescription);

                            await LeadConnection.showMyDialog(
                                context, result.errorDescription);
                            Navigator.of(context).pop(true);
                          } else {
                            LeadConnection.showMyDialog(
                                context, result.errorDescription);
                          }
                        }
                      }),
                      (detail.saleId == null)
                          ? _buildFunction(
                              AppLocalizations.text(LangKey.assignment),
                              Assets.iconAssignment,
                              Color(0xFF2F9AF4), () async {
                              int staffID = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => AllocatorScreen()));

                              if (staffID != null) {
                                DescriptionModelResponse result =
                                    await LeadConnection.assignRevokeLead(
                                        context,
                                        AssignRevokeLeadRequestModel(
                                            type: "assign",
                                            customerLeadCode:
                                                detail.customerLeadCode,
                                            saleId: staffID,
                                            timeRevokeLead: 30));

                                if (result != null) {
                                  if (result.errorCode == 0) {
                                    print(result.errorDescription);

                                    await LeadConnection.showMyDialog(
                                        context, result.errorDescription);
                                    getData();
                                  } else {
                                    LeadConnection.showMyDialog(
                                        context, result.errorDescription);
                                  }
                                }
                              }
                            })
                          : _buildFunction(
                              AppLocalizations.text(LangKey.recall),
                              Assets.iconRecall,
                              Color(0xFF2F9AF4), () async {
                              DescriptionModelResponse result =
                                  await LeadConnection.assignRevokeLead(
                                      context,
                                      AssignRevokeLeadRequestModel(
                                          type: "revoke",
                                          customerLeadCode:
                                              detail.customerLeadCode,
                                          saleId: detail.saleId,
                                          timeRevokeLead: 30));

                              if (result != null) {
                                if (result.errorCode == 0) {
                                  print(result.errorDescription);

                                  await LeadConnection.showMyDialog(
                                      context, result.errorDescription);
                                  getData();
                                } else {
                                  LeadConnection.showMyDialog(
                                      context, result.errorDescription);
                                }
                              }
                            }),
                      _buildFunction(
                          AppLocalizations.text(LangKey.createJobs),
                          Assets.iconTask,
                          Color.fromARGB(255, 243, 180, 125), () {
                        print("task");
                      })
                    ],
                  )),
              Expanded(
                  child: ListView(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _controller,
                children: buildInfomation(),
              )),
              buildButtonConvert(
                  AppLocalizations.text(LangKey.convertCustomers), () {
                print("chuyen doi khach hang");
              }),
              buildButtonConvert(
                  AppLocalizations.text(LangKey.convertCustomersWithDeal), () {
                print("chuyen doi khach hang co tao deal");
              }),
              Container(
                height: 20.0,
              )
            ],
          );
  }

  List<Widget> buildInfomation() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(color: AppColors.lightGrey),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildAvatar(detail?.fullName ?? ""),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40.0,
                      padding: EdgeInsets.only(left: 15.0 / 1.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Lead",
                            style: AppTextStyles.style14BlackWeight500,
                          ),
                          Text(
                            detail?.fullName ?? "",
                            style: TextStyle(
                                fontSize: AppTextSizes.size18,
                                color: AppColors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: AppColors.white),
            padding: const EdgeInsets.all(8.0),
            // margin: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              children: [
                _phoneNumberItem(),
                const Divider(),
                _infoItem(AppLocalizations.text(LangKey.customerSource),
                    detail?.customerSourceName ?? ""),
                const Divider(),
                _infoItem(AppLocalizations.text(LangKey.customerStyle),
                    detail?.customerType ?? ""),
                const Divider(),
                (detail?.saleId != null) ? _infoItem(AppLocalizations.text(LangKey.allottedPerson),
                    detail?.saleName ?? "") : Container(),
                 (detail?.saleId != null) ? Divider() : Container(),
                _infoItem(AppLocalizations.text(LangKey.pipeline),
                    detail?.pipelineName ?? ""),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            height: 5.0,
            decoration: const BoxDecoration(
              color: AppColors.lightGrey,
            ),
          ),
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: builJourneyTracking(),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 8.0),
            height: 5.0,
            decoration: const BoxDecoration(
              color: AppColors.lightGrey,
            ),
          ),
          SubDetailPotentialCustomer(
            detail: detail,
          )
        ],
      )
    ];
  }

  Widget builJourneyTracking() {
    int lenght = detail?.journeyTracking?.length ?? 0;
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        Row(
          children: [
            Container(
              width: 10.0,
            ),
            (lenght > 0)
                ? journeyitem(AppLocalizations.text(LangKey.newDeal),
                    detail.journeyTracking[0].check, 130.0)
                : Container(),
            (lenght > 1)
                ? journeyitem(AppLocalizations.text(LangKey.haveInfomation),
                    detail.journeyTracking[1].check, 190.0)
                : Container(),
            (lenght > 2)
                ? journeyitem(AppLocalizations.text(LangKey.consulting),
                    detail?.journeyTracking[2].check, 190.0)
                : Container(),
            (lenght > 3)
                ? journeyitem(AppLocalizations.text(LangKey.negotiate),
                    detail.journeyTracking[3].check, 190.0)
                : Container(),
            (lenght > 4)
                ? journeyitem(AppLocalizations.text(LangKey.success),
                    detail.journeyTracking[4].check, 180.0)
                : Container(),
            (lenght > 5)
                ? journeyitem(AppLocalizations.text(LangKey.fail),
                    detail.journeyTracking[5].check, 180.0)
                : Container(),
            Container(
              width: 30,
            )
          ],
        ),
        (lenght > 0)
            ? positionJourney(
                126,
                detail.journeyTracking[0].check
                    ? Color(0xFF0BC50B)
                    : Color(0xFFF99843))
            : Container(),
        (lenght > 1)
            ? positionJourney(
                316,
                detail.journeyTracking[1].check
                    ? Color(0xFF0BC50B)
                    : Color(0xFFF99843))
            : Container(),
        (lenght > 2)
            ? positionJourney(
                506,
                detail.journeyTracking[2].check
                    ? Color(0xFF0BC50B)
                    : Color(0xFFF99843))
            : Container(),
        (lenght > 3)
            ? positionJourney(
                696,
                detail.journeyTracking[3].check
                    ? Color(0xFF0BC50B)
                    : Color(0xFFF99843))
            : Container(),
        (lenght > 4)
            ? positionJourney(
                876,
                detail.journeyTracking[4].check
                    ? Color(0xFF0BC50B)
                    : Color(0xFFF99843))
            : Container(),
        (detail.journeyTracking.length > 5)
            ? positionJourney(
                1056,
                detail.journeyTracking[5].check
                    ? Color(0xFF0BC50B)
                    : Color(0xFFF99843))
            : Container(),
        // positionJourney(116),
      ],
    );
  }

  Widget journeyitem(String title, bool status, double width) {
    return Container(
      // margin: EdgeInsets.only(right: margin) ,
      decoration: BoxDecoration(
        color: status ? const Color(0xFF0BC50B) : const Color(0xFFF99843),
      ),
      width: width,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          status
              ? Icon(Icons.check, color: Color(0xFFFFFFFF))
              : Image.asset(
                  Assets.iconWait,
                  color: Color(0xFFFFFFFF),
                  width: 24.0,
                ),
          Container(
            width: 4.0,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: AppTextSizes.size15,
                color:
                    status ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget positionJourney(double left, Color color) {
    return Positioned(
      left: left,
      bottom: 5,
      child: Transform.rotate(
        angle: 45 * pi / 180,
        child: Container(
            decoration: BoxDecoration(
                color: color,
                border: const Border(
                    top: BorderSide(color: AppColors.lineColor, width: 2.0),
                    right: BorderSide(color: AppColors.lineColor, width: 2.0))),
            height: 30,
            width: 30),
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

  Widget _phoneNumberItem() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      margin: EdgeInsets.only(left: 15.0 / 2),
      child: Row(
        children: [
          Container(
            width: (MediaQuery.of(context).size.width) / 1.9,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    AppLocalizations.text(LangKey.phoneNumber),
                    style: AppTextStyles.style15BlackNormal,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(detail?.phone ?? "",
                style: AppTextStyles.style16BlueWeight500),
          ),
          InkWell(
            onTap: () {
              callPhone(detail?.phone ?? "");
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              height: 30,
              width: 30,
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
      padding: const EdgeInsets.all(2.0),
      decoration: const BoxDecoration(
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

  Widget _buildFunction(String name, String icon, Color color, Function ontap) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            padding: (name == AppLocalizations.text(LangKey.recall))
                ? EdgeInsets.all(8.0)
                : EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Image.asset(
              icon,
            ),
          ),
          Container(height: 8.0),
          Text(name)
        ],
      ),
    );
  }

  Widget buildButtonConvert(String title, Function ontap) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: ontap,
        child: Center(
          child: Text(
            // AppLocalizations.text(LangKey.convertCustomers),
            title,
            style: AppTextStyles.style16WhiteBold,
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
  SubDetailPotentialCustomer({Key key, this.detail}) : super(key: key);

  @override
  _SubDetailPotentialCustomerState createState() =>
      _SubDetailPotentialCustomerState();
}

class _SubDetailPotentialCustomerState
    extends State<SubDetailPotentialCustomer> {
  int index = 0;

  List<DetailPotentialTabModel> tabPotentials = [
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.generalInfomation),
        typeID: 1,
        selected: true),
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.infomationDeal),
        typeID: 2,
        selected: false),
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.customerCare),
        typeID: 3,
        selected: false),
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.historyCare),
        typeID: 4,
        selected: false)
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: buildListOption(),
        ),
        // Container(
        //   height: 20,
        // ),
        (index == 0) ? generalInfomation() : dealInfomation()
      ],
    );
  }

  Widget buildListOption() {
    return Row(
      children: [
        option(AppLocalizations.text(LangKey.generalInfomation),
            tabPotentials[0].selected, 100, () {
          index = 0;
          selectedTab(0);
        }),
        option(AppLocalizations.text(LangKey.infomationDeal),
            tabPotentials[1].selected, 100, () {
          index = 1;
          selectedTab(1);
        }),
        option(AppLocalizations.text(LangKey.customerCare),
            tabPotentials[2].selected, 150, () {
          index = 2;
          selectedTab(2);
        }),
        option(AppLocalizations.text(LangKey.historyCare),
            tabPotentials[3].selected, 120, () {
          index = 3;
          selectedTab(3);
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

  Widget generalInfomation() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              AppLocalizations.text(LangKey.picture),
              style: TextStyle(
                  fontSize: AppTextSizes.size15,
                  color: const Color(0xFF858080),
                  fontWeight: FontWeight.normal),
            ),
          ),

          Center(
            child: _buildAvatarImg(widget.detail.fullName),
          ),

          const Divider(),

          _infoItem(
              AppLocalizations.text(LangKey.email), widget.detail?.email ?? "",
              icon: Assets.iconEmail),
          const Divider(),
          sexInfo(widget.detail?.gender ?? ""),
          const Divider(),
          _infoItem(AppLocalizations.text(LangKey.provinceCity),
              "${widget.detail?.provinceType ?? ""} ${widget.detail?.provinceName ?? ""}",
              icon: Assets.iconProvince),
          const Divider(),
          _infoItem(AppLocalizations.text(LangKey.district),
              "${widget.detail?.districtType ?? ""} ${widget.detail?.districtName ?? ""}",
              icon: Assets.iconDistrict),
          const Divider(),
          // _infoItem(AppLocalizations.text(LangKey.wards),
          //     "${widget.detail?.wardType ?? ""} ${widget.detail?.wardName ?? ""}",
          //     icon: Assets.iconWards),
          // const Divider(),
          _infoItem(AppLocalizations.text(LangKey.address),
              widget.detail?.address ?? "",
              icon: Assets.iconAddress),
          const Divider(),
          _infoItem(AppLocalizations.text(LangKey.businessFocalPoint),
              widget.detail?.businessClue ?? "",
              icon: Assets.iconPoint),
          const Divider(),
          _infoItem(
              AppLocalizations.text(LangKey.zalo), widget.detail?.zalo ?? "",
              icon: Assets.iconSource, icon2: Assets.iconZalo),
          const Divider(),
          _infoItem(AppLocalizations.text(LangKey.fanpage),
              widget.detail?.fanpage ?? "",
              icon: Assets.iconFanpage, icon2: Assets.iconMessenger)
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

  Widget dealInfomation() {
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
          sex != ""  ? Container(
            height: 40,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                sex != "other" ? Container(
                  margin: const EdgeInsets.only(
                    right: 4.0,
                  ),
                  height: 20.0,
                  width: 20.0,
                  child: sex == "male"
                      ? Image.asset(Assets.iconMale)
                      : Image.asset(Assets.iconFemale),
                ) : Container(),
                Text(
                  sex == "other" ? AppLocalizations.text(LangKey.other) : sex == "male"
                      ? AppLocalizations.text(LangKey.male)
                      : AppLocalizations.text(LangKey.female),
                  style: AppTextStyles.style15BlackNormal,
                  maxLines: 1,
                )
              ],
            ),
          ) : Container()
        ],
      ),
    );
  }

  Widget _buildAvatarImg(String name) {
    return Container(
      width: 65.0,
      height: 65.0,
      padding: const EdgeInsets.all(2.0),
      decoration: const BoxDecoration(
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

  selectedTab(int index) async {
    List<DetailPotentialTabModel> models = tabPotentials;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;

    setState(() {});
  }
}
