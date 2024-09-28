import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/constant.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/note_file_req_res_model.dart';
import 'package:lead_plugin_epoint/model/request/assign_revoke_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/care_lead_response_model.dart';
import 'package:lead_plugin_epoint/model/response/contact_list_model_response.dart';
import 'package:lead_plugin_epoint/model/response/description_model_response.dart';
import 'package:lead_plugin_epoint/model/response/detail_lead_info_deal_response_model.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/bloc/detail_potential_customer_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/chat_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/edit_potential_customer/edit_potential_customer.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/note_module/ui/list_note_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/pick_one_staff_screen/ui/pick_one_staff_screen.dart';
import 'package:lead_plugin_epoint/utils/global.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/utils/visibility_api_widget_name.dart';
import 'package:lead_plugin_epoint/widget/container_data_builder.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar_with_url.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_file_view.dart';
import 'package:lead_plugin_epoint/widget/custom_information_lead_widget.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:lead_plugin_epoint/widget/custom_row_image_content_widget.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';
import 'package:lead_plugin_epoint/widget/widget.dart';
import 'dart:ui' as ui;

class DetailPotentialCustomer extends StatefulWidget {
  final String? customer_lead_code;
  final int? indexTab;
  bool? customerCare;
  int? id;
  String? typeCustomer;
  Function(int)? onCallback;
  DetailPotentialCustomer(
      {Key? key,
      this.customer_lead_code,
      this.indexTab,
      this.typeCustomer,
      this.customerCare,
      this.id,
      this.onCallback})
      : super(key: key);

  @override
  _DetailPotentialCustomerState createState() =>
      _DetailPotentialCustomerState();
}

class _DetailPotentialCustomerState extends State<DetailPotentialCustomer>
    with AutomaticKeepAliveClientMixin<DetailPotentialCustomer> {
  final double _radius = 5.0;

  late String _lang;

  final ScrollController _controller = ScrollController();
  List<WorkListStaffModel> models = [];
  List<ContactListData>? contactListData;
  List<CareLeadData>? customerCareLead;
  DetailPotentialData? detail;
  List<DetailLeadInfoDealData>? detailLeadInfoDealData;

  List<DetailPotentialTabModel> tabPotentials = [
    DetailPotentialTabModel(typeName: "Liên quan", index: 0, selected: true),
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.generalInfomation),
        index: 1,
        selected: false),
  ];
  int? index = 0;
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    decimalDigits: 0,
    symbol: '',
  );

  late DetailPotentialCustomerBloc _bloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _bloc = DetailPotentialCustomerBloc(context);
    _lang = LangKey.langDefault;

    index = widget.indexTab;
    for (int i = 0; i < tabPotentials.length; i++) {
      if (index == tabPotentials[i].index) {
        tabPotentials[i].selected = true;
      } else {
        tabPotentials[i].selected = false;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // getData();

      _bloc.getData(widget.customer_lead_code!).then(
        (value) {
          if (value) {
            detail = _bloc.detail;
            setState(() {});
          }
        },
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  openFile(BuildContext context, String? name, String? path) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CustomFileView(path, name)));
  }

  Widget buildBody() {
    return (detail == null)
        ? Container()
        : StreamBuilder(
            stream: _bloc.outputModel,
            initialData: _bloc.detail,
            builder: (context, snapshot) {
              _bloc.detail = snapshot.data as DetailPotentialData?;
              detail = _bloc.detail;
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: AppSizes.maxHeight * 0.1 +
                            (index == 0 ? 0 : AppSizes.maxPadding + 16)),
                    child: Column(
                      children: [
                        buildListOption(),
                        Expanded(child: buildInfomation()),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: AppSizes.maxHeight * 0.1 +
                            (index == 0 ? 0 : AppSizes.maxPadding + 16),
                        child: (index == 0)
                            ? _listButtonRelevant()
                            : _listButtonInfo()),
                  )
                ],
              );
            });
  }

  Widget buildInfomation() {
    return (index == 0)
        ? _listInfomationRelevant()
        : generalInfomationV2();
  }

  Widget buildListOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        option(tabPotentials[0].typeName!, tabPotentials[0].selected!, 100, () {
          index = 0;
          selectedTab(0);
        }),
        option(tabPotentials[1].typeName!, tabPotentials[1].selected!, 100,
            () async {
          index = 1;
          selectedTab(1);
        }),
      ],
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

  Widget option(
      String title, bool show, double width, GestureTapCallback ontap) {
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

  Widget _listInfomationRelevant() {
    return Padding(
      padding: EdgeInsets.all(AppSizes.minPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(
                  text: _bloc.detail!.customerType == "personal"
                      ? "${AppLocalizations.text(LangKey.personal)} - "
                      : "${AppLocalizations.text(LangKey.business)} - ",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                  children: [
                TextSpan(
                    text: detail!.fullName,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold))
              ])),
          SizedBox(
            height: AppSizes.minPadding / 2,
          ),
          CustomRowImageContentWidget(
            icon: Assets.iconPerson,
            title: detail!.customerLeadCode ?? NULL_VALUE,
          ),
          SizedBox(
            height: AppSizes.minPadding / 2,
          ),
          CustomRowImageContentWidget(
            icon: Assets.iconUserGroup,
            title: detail!.customerGroupName ?? NULL_VALUE,
          ),
          SizedBox(
            height: AppSizes.minPadding / 2,
          ),
          CustomRowImageContentWidget(
              icon: Assets.iconCall, title: detail?.phone ?? NULL_VALUE),
          SizedBox(
            height: AppSizes.minPadding / 2,
          ),
          CustomRowImageContentWidget(
            icon: Assets.iconInteraction,
            child: RichText(
                text: TextSpan(
                    text: detail!.dateLastCare! + " ",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                    children: [
                  TextSpan(
                      text: "(${detail!.diffDay} ngày)",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal))
                ])),
          ),
          infomationRelevant()
        ],
      ),
    );
  }

  // Widget generalInfomationV2() {
  //   return StreamBuilder(
  //       stream: _bloc.outputModel,
  //       initialData: _bloc.detail,
  //       builder: (context, snapshot) {
  //         _bloc.detail = snapshot.data as DetailPotentialData?;
  //         detail = _bloc.detail;
  //         return (_bloc.detail != null)
  //             ? _bloc.detail!.customerType == "personal"
  //                 ? generalInfomationPersonal()
  //                 : generalInfomationBusiness()
  //             : SizedBox();
  //       });
  // }

  Widget _buildRow(Widget child, Widget child1) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: child),
        SizedBox(
          width: AppSizes.minPadding,
        ),
        Expanded(child: child1)
      ],
    );
  }

  Widget _buildInfo(DetailPotentialData model) {
    return Row(
      children: [
        CustomAvatar(
          url: model.avatar,
          name: model.fullName,
          size: 60.0,
        ),
        SizedBox(
          width: AppSizes.minPadding,
        ),
        Expanded(
            child: CustomListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Text(
              model.fullName ?? "",
              style: AppTextStyles.style14PrimaryBold,
            ),
            if ((model.customerTypeName ?? "").isNotEmpty)
              Text(
                model.customerTypeName ?? "",
                style: AppTextStyles.style14HintNormal,
              ),
            if ((model.phone ?? "").isNotEmpty)
              Text(
                hidePhone(model.phone,
                    checkVisibilityKey(VisibilityWidgetName.CM000004)),
                style: AppTextStyles.style14BlackNormal,
              ),
          ],
        )),
      ],
    );
  }

  Widget _buildCode(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconBarcode,
        title: "Mã khách hàng",
        content: model.customerLeadCode);
  }

  Widget _buildEmail(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconMail,
        title: AppLocalizations.text(LangKey.email),
        content: hideEmail(
            model.email, checkVisibilityKey(VisibilityWidgetName.CM000004)));
  }

  Widget _buildWebsite(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconWebsite,
        title: "Website",
        content: hideSocial(
            model.hotline, checkVisibilityKey(VisibilityWidgetName.CM000004)));
  }

  Widget _buildAddress(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconMarker,
        title: AppLocalizations.text(LangKey.address),
        content: model.fullAddress);
  }

  Widget _buildJourney(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconItinerary,
        title: AppLocalizations.text(LangKey.journey),
        content: model.journeyName);
  }

  Widget _buildPipeline(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconPin,
        title: AppLocalizations.text(LangKey.pipeline),
        content: model.pipelineName);
  }

  Widget _buildSource(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconUserGroup,
        title: AppLocalizations.text(LangKey.customer_source),
        content: model.customerSourceName);
  }

  Widget _buildGroup(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconGroup,
        title: AppLocalizations.text(LangKey.customer_group),
        content: model.customerGroupName);
  }

  Widget _buildTag(DetailPotentialData model) {
    return CustomColumnIconInformation(
      icon: Assets.iconTagFill,
      title: AppLocalizations.text(LangKey.tags),
      child: (model.tag?.length ?? 0) > 0
          ? SizedBox(
              width: double.infinity,
              child: Wrap(
                children: List.generate(detail!.tag!.length,
                    (index) => _tagDetail(detail!.tag![index])),
                spacing: 10,
                runSpacing: 10,
              ),
            )
          : null,
    );
  }

  Widget _buildAllottedPersone(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconPersonTag,
        title: AppLocalizations.text(LangKey.allottedPerson),
        content: model.saleName);
  }

  Widget _buildPresenter(DetailPotentialData model) {
    return CustomColumnIconInformation(
      icon: Assets.iconSearch,
      title: AppLocalizations.text(LangKey.presenter),
      content: model.customerLeadReferName ?? "",
      styleContent: _bloc.detail!.customerLeadReferId == null
          ? null
          : AppTextStyles.style14PrimaryBold
              .copyWith(decoration: TextDecoration.underline),
      onTap: _bloc.detail!.customerLeadReferId == null
          ? null
          : _bloc.onPushPresenter,
    );
  }

  Widget _buildFoundingDate(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconCalendarFill,
        title: AppLocalizations.text(LangKey.founding_date),
        content: model.birthday);
  }

  Widget _buildGender(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconGen,
        title: AppLocalizations.text(LangKey.gender),
        content: model.gender == genderMale
            ? AppLocalizations.text(LangKey.male)
            : model.gender == genderFemale
                ? AppLocalizations.text(LangKey.female)
                : AppLocalizations.text(LangKey.other));
  }

  Widget _buildDate(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconCalendarFill,
        title: AppLocalizations.text(LangKey.birthday),
        content: model.birthday);
  }

  Widget _buildZalo(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconZalo,
        title: "Zalo",
        content: hideSocial(
            model.zalo, checkVisibilityKey(VisibilityWidgetName.CM000004)));
  }

  Widget _buildFacebook(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconFacebook,
        title: "Facebook",
        content: hideSocial(
            model.fanpage, checkVisibilityKey(VisibilityWidgetName.CM000004)));
  }

  Widget _buildTaxCode(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconTax,
        title: AppLocalizations.text(LangKey.tax_code_1),
        content: model.taxCode);
  }

  Widget _buildArea(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconBusinessArea,
        title: AppLocalizations.text(LangKey.business_areas),
        content: model.businessName);
  }

  Widget _buildRepresentative(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconUserStand,
        title: AppLocalizations.text(LangKey.representative),
        content: model.representative);
  }

  Widget _buildQuantity(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconQuantity,
        title: AppLocalizations.text(LangKey.number_of_employees),
        content: (model.employQty ?? "").toString());
  }

  Widget _buildBranch(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconBranch,
        title: AppLocalizations.text(LangKey.branch),
        content: model.branchName);
  }

  Widget _buildCreateBy(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconUserSetting,
        title: AppLocalizations.text(LangKey.creator),
        content: model.createdByName);
  }

  Widget _buildUpdateBy(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconUserUpdate,
        title: AppLocalizations.text(LangKey.updater),
        content: model.updatedByName);
  }

  Widget _buildNote(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconEditNote,
        title: AppLocalizations.text(LangKey.note),
        content: model.note);
  }

  Widget generalInfomationV2() {
    return StreamBuilder(
      stream: _bloc.outputModel,
      initialData: null,
      builder: (_, snapshot) {
        DetailPotentialData? model = snapshot.data as DetailPotentialData?;
        return ContainerDataBuilder(
          data: model,
          skeletonBuilder: _buildSkeleton(),
          bodyBuilder: () {
            bool isPersonal = model!.customerType == customerTypePersonal;
            return CustomListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              separatorPadding: AppSizes.maxPadding,
              children: [
                _buildInfo(model),
                _buildRow(_buildCode(model), _buildEmail(model)),
                if (!isPersonal) _buildWebsite(model),
                _buildAddress(model),
                _buildRow(_buildPipeline(model), _buildJourney(model)),
                _buildRow(_buildSource(model), _buildGroup(model)),
                _buildAllottedPersone(model),
                _buildTag(model),
                _buildPresenter(model),
                if (!isPersonal)
                  _buildFoundingDate(model)
                else
                  _buildRow(
                    _buildGender(model),
                    _buildDate(model),
                  ),
                _buildRow(_buildZalo(model), _buildFacebook(model)),
                if (!isPersonal) ...[
                  _buildRow(_buildTaxCode(model), _buildArea(model)),
                  _buildRow(_buildRepresentative(model), _buildQuantity(model)),
                ],
                _buildRow(_buildBranch(model), _buildCreateBy(model)),
                _buildUpdateBy(model),
                _buildNote(model)
              ],
              onRefresh: () => _bloc.getData(_bloc.detail!.customerLeadCode!),
            );
          },
        );
      },
    );
  }

  // Widget generalInfomationPersonal() {
  //   return Container(
  //     padding: EdgeInsets.all(8.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         CustomInfomationLeadWidget(
  //           avatarUrl: detail?.avatar,
  //           name: detail?.fullName ?? "",
  //           type: detail!.customerType == "personal"
  //               ? AppLocalizations.text(LangKey.personal)
  //               : AppLocalizations.text(LangKey.business),
  //         ),
  //         SizedBox(
  //           height: AppSizes.minPadding,
  //         ),
  //         CustomRowImageContentWidget(
  //           icon: Assets.iconCall,
  //           title: hidePhone(
  //                               detail?.phone ?? "",
  //                               checkVisibilityKey(
  //                                   VisibilityWidgetName.LE000002)),
  //         ),
  //         SizedBox(
  //           height: AppSizes.minPadding! / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconEmail,
  //             title: hideEmail(detail?.email ?? "",
  //                         checkVisibilityKey(VisibilityWidgetName.LE000002)) !=
  //                     ""
  //                 ? hideEmail(detail?.email ?? "",
  //                     checkVisibilityKey(VisibilityWidgetName.LE000002))
  //                 : NULL_VALUE),
  //         SizedBox(
  //           height: AppSizes.minPadding! / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //           icon: Assets.iconAddress,
  //           title: "Địa chỉ: ${detail!.fullAddress ?? NULL_VALUE}",
  //         ),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //           icon: Assets.iconUserGroup,
  //           title: "Nhóm khách hàng: ${detail!.customerGroupName ?? NULL_VALUE}",
  //         ),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //           icon: Assets.iconSourceCustomer,
  //           title: "Nguồn khách hàng: ${detail!.customerSourceName ?? NULL_VALUE}",
  //         ),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //           icon: Assets.iconSearch,
  //           iconColor: AppColors.primaryColor,
  //           child:Row(
  //             children: [
  //               _buildSaleNameText(detail?.customerLeadReferName ?? NULL_VALUE),
  //               _buildIntroductionText(),
  //             ],
  //           ),
  //         ),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconSex, title: "Giới tính: ${getGenderText(detail!.gender ?? "")}"),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconPin,
  //             title:
  //                 "${AppLocalizations.text(LangKey.pipeline)}: ${detail?.pipelineName ?? NULL_VALUE} "),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconItinerary,
  //             title:
  //                 "${AppLocalizations.text(LangKey.journey)}: ${detail?.journeyName ?? NULL_VALUE} "),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconBirthday,
  //             title: "Ngày sinh: ${detail?.birthday ?? NULL_VALUE} "),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconWebsite,
  //             child: _buildLink(hideSocial(detail?.website ?? "",
  //                         checkVisibilityKey(VisibilityWidgetName.LE000002)) !=
  //                     ""
  //                 ? hideSocial(detail?.fanpage ?? "",
  //                     checkVisibilityKey(VisibilityWidgetName.LE000002))
  //                 : NULL_VALUE)),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconSource,
  //             child: _buildLink(hideSocial(detail?.zalo ?? "",false))),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconFanpage,
  //             child: _buildLink(hideSocial(detail?.fanpage ?? "",
  //                         checkVisibilityKey(VisibilityWidgetName.LE000002)) !=
  //                     ""
  //                 ? hideSocial(detail?.fanpage ?? "",
  //                     checkVisibilityKey(VisibilityWidgetName.LE000002))
  //                 : NULL_VALUE)),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconBranch, title: "Chi nhánh: ${detail?.branchName ?? NULL_VALUE} "),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconPersonTag,
  //             title:
  //                 "${AppLocalizations.text(LangKey.allottedPerson)}: ${detail?.saleName ?? NULL_VALUE}"),
  //         if (detail?.tag != null && (detail?.tag!.length ?? 0) > 0)
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Image.asset(
  //                 Assets.iconTag,
  //                 scale: 3.0,
  //               ),
  //               SizedBox(width: AppSizes.minPadding),
  //               Expanded(
  //                 child: Container(
  //                   child: Wrap(
  //                     children: List.generate(detail!.tag!.length,
  //                         (index) => _tagDetail(detail!.tag![index])),
  //                     spacing: 10,
  //                     runSpacing: 10,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         Padding(
  //           padding: EdgeInsets.only(left: 8.0),
  //           child: Text(
  //             "Ghi chú",
  //             style: AppTextStyles.style14PrimaryBold,
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(left: 8.0),
  //           child: Text(
  //             detail?.note ?? NULL_VALUE,
  //             style: AppTextStyles.style14BlackNormal,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget generalInfomationBusiness() {
  //   return Container(
  //     padding: EdgeInsets.all(8.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         CustomInfomationLeadWidget(
  //           avatarUrl: detail?.avatar,
  //           name: detail?.fullName ?? "",
  //           type: detail!.customerType == "personal"
  //               ? AppLocalizations.text(LangKey.personal)
  //               : AppLocalizations.text(LangKey.business),
  //         ),
  //         SizedBox(
  //           height: AppSizes.minPadding,
  //         ),
  //         CustomRowImageContentWidget(
  //           icon: Assets.iconCall,
  //           title:  hidePhone(
  //                               detail?.phone ?? "",
  //                               checkVisibilityKey(
  //                                   VisibilityWidgetName.CM000004)),
  //         ),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconEmail,
  //             title: hideEmail(detail?.email ?? "",
  //                         checkVisibilityKey(VisibilityWidgetName.LE000002)) !=
  //                     ""
  //                 ? hideEmail(detail?.email ?? "",
  //                     checkVisibilityKey(VisibilityWidgetName.LE000002))
  //                 : NULL_VALUE),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //           icon: Assets.iconAddress,
  //           title: detail!.fullAddress ?? NULL_VALUE,
  //         ),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //           icon: Assets.iconSourceCustomer,
  //           title: detail!.customerSourceName ?? NULL_VALUE,
  //         ),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //           icon: Assets.iconSearch,
  //           iconColor: AppColors.primaryColor,
  //           child:Row(
  //             children: [
  //               _buildSaleNameText(detail?.customerLeadReferName ?? NULL_VALUE),
  //               _buildIntroductionText(),
  //             ],
  //           ),
  //         ),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconPin,
  //             title:
  //                 "${AppLocalizations.text(LangKey.pipeline)}: ${detail?.pipelineName} "),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconItinerary,
  //             title:
  //                 "${AppLocalizations.text(LangKey.journey)}: ${detail?.journeyName} "),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconBranch, title: "Chi nhánh: ${detail?.branchName ?? NULL_VALUE}  "),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconPersonTag,
  //             title:
  //                 "${AppLocalizations.text(LangKey.allottedPerson)}: ${detail?.saleName ?? NULL_VALUE}"),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconProject,
  //             title:
  //                 "${AppLocalizations.text(LangKey.businessAreas)}: ${detail?.businessName ?? NULL_VALUE}"),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconWebsite,
  //             title: "Website: ${detail?.website ?? NULL_VALUE}"),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconSource,
  //             child: _buildLink(hideSocial(detail?.zalo ?? "",
  //                         checkVisibilityKey(VisibilityWidgetName.LE000002)) !=
  //                     ""
  //                 ? hideSocial(detail?.zalo ?? "",
  //                     checkVisibilityKey(VisibilityWidgetName.LE000002))
  //                 : NULL_VALUE)),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconFanpage,
  //             child: _buildLink(hideSocial(detail?.fanpage ?? "",
  //                         checkVisibilityKey(VisibilityWidgetName.LE000002)) !=
  //                     ""
  //                 ? hideSocial(detail?.fanpage ?? "",
  //                     checkVisibilityKey(VisibilityWidgetName.LE000002))
  //                 : NULL_VALUE)),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconBirthday,
  //             title: "Ngày thành lập: ${detail?.birthday ?? NULL_VALUE}"),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconTax,
  //             title:
  //                 "${AppLocalizations.text(LangKey.tax)}: ${detail?.taxCode ?? NULL_VALUE}"),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconNumberEmployees,
  //             title:
  //                 "${AppLocalizations.text(LangKey.numberEmployees)}: ${detail?.employees ?? NULL_VALUE}"),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconRepresentative,
  //             title:
  //                 "${AppLocalizations.text(LangKey.representative)} - ${detail?.representative ?? NULL_VALUE}"),
  //         SizedBox(
  //           height: AppSizes.minPadding / 2,
  //         ),
  //         CustomRowImageContentWidget(
  //             icon: Assets.iconContact,
  //             title:
  //                 "${AppLocalizations.text(LangKey.contactPerson)} - ${detail?.customerContactName ?? NULL_VALUE}"),
  //         if (detail?.tag != null && (detail?.tag!.length ?? 0) > 0)
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Image.asset(
  //                 Assets.iconTag,
  //                 scale: 3.0,
  //               ),
  //               SizedBox(width: AppSizes.minPadding),
  //               Expanded(
  //                 child: Container(
  //                   child: Wrap(
  //                     children: List.generate(detail!.tag!.length,
  //                         (index) => _tagDetail(detail!.tag![index])),
  //                     spacing: 10,
  //                     runSpacing: 10,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         Padding(
  //           padding: EdgeInsets.only(left: 8.0),
  //           child: Text(
  //             "Ghi chú",
  //             style: AppTextStyles.style14PrimaryBold,
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(left: 8.0),
  //           child: Text(
  //             _bloc.detail?.note ?? NULL_VALUE,
  //             style: AppTextStyles.style14BlackNormal,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

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

  String getGenderText(String gender) {
    switch (gender) {
      case "male":
        return AppLocalizations.text(LangKey.male)!;
      case "female":
        return AppLocalizations.text(LangKey.female)!;
      case "other":
        return AppLocalizations.text(LangKey.other)!;
      default:
        return NULL_VALUE;
    }
  }

  Widget _buildSaleNameText(String? saleName) {
    return Text(
      saleName ?? "",
      style: TextStyle(
        decoration: TextDecoration.underline,
        decorationColor: Colors.blue,
        decorationStyle: TextDecorationStyle.solid,
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildLink(String? link) {
    return Text(
      link ?? "",
      style: TextStyle(
        decorationColor: Colors.blue,
        decorationStyle: TextDecorationStyle.solid,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildIntroductionText() {
    return Text(
      " là người giới thiệu",
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      ),
    );
  }

  Widget dealInfomationV2() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child:
          (detailLeadInfoDealData != null && detailLeadInfoDealData!.length > 0)
              ? Column(
                  children: detailLeadInfoDealData!
                      .map((e) => dealInfomationItem(e))
                      .toList())
              : CustomDataNotFound(),
    );
  }

  Widget dealInfomationItem(DetailLeadInfoDealData item) {
    return InkWell(
      onTap: () async {
        if (Global.openDetailDeal != null) {
          var result = await Global.openDetailDeal!(item.dealCode!);
          if (result != null) {
            _bloc.allowPop = true;
            await _bloc.getData(widget.customer_lead_code!);
          }
        }
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
              padding: EdgeInsets.only(top: 5.0, right: 5.0, bottom: 5.0),
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
                      child: Text(item.journeyName ?? NULL_VALUE,
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

  Widget customerCareItem(CareLeadData item) {
    final createTime = DateTime.parse(item.createdAt ?? "");

    return InkWell(
      onTap: () async {
        if (Global.editJob != null) {
          var result = await Global.editJob!(item.manageWorkId ?? 0);
          if (result != null) {
            _bloc.allowPop = true;
            await _bloc.getData(widget.customer_lead_code!);
          }
        }
      },
      child: Container(
        child: Container(
          // margin: EdgeInsets.all(10),
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
                    children: [
                      Text(
                        "${createTime.hour}:${createTime.minute}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '${createTime.day},\ntháng ${createTime.month},\nnăm ${createTime.year}',
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
                        padding: EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text:
                                      "[${item.manageWorkCode}] ${item.manageWorkTitle}",
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

                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.3),
                          )
                        ], color: Colors.white),
                        child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomNetworkImage(
                                width: 15,
                                height: 15,
                                url: item?.manageTypeWorkIcon ??
                                    "https://epoint-bucket.s3.ap-southeast-1.amazonaws.com/0f73a056d6c12b508a05eea29735e8a52022/07/14/3Ujo25165778317714072022.png",
                                fit: BoxFit.fill,
                                backgroundColor: Colors.transparent,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                item.manageTypeWorkName ?? NULL_VALUE,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500),
                                // maxLines: 1,
                              ),
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
                                  "${item.countFile}",
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
                                  "${item.countComment}",
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
                                  "${item.daysLate}",
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
                              name: item.staffFullName ?? NULL_VALUE,
                              url: item.staffAvatar ?? "",
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
                                  item.staffFullName ?? NULL_VALUE,
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

                      (item.listTag != null && item.listTag!.length > 0)
                          ? Container(
                              child: Wrap(
                                children: List.generate(
                                    item.listTag!.length,
                                    (index) => _tagItemCustomCare(
                                        item.listTag![index])),
                                spacing: 10,
                                runSpacing: 10,
                              ),
                            )
                          : Container()

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

  Widget _tagItemCustomCare(ListTagCareLead item) {
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
            item.tagName!,
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

  Widget _tagDetail(Tag item) {
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
                        await _callPhone(item.phone ?? "");
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

  _callPhone(String phone) async {
    await FlutterPhoneDirectCaller.callNumber(phone);
  }

  Widget buildButtonConvert(String title, GestureTapCallback ontap) {
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

  Widget infomationRelevant() {
    return StreamBuilder(
        stream: _bloc.outputModel,
        initialData: null,
        builder: (_, snapshot) {
          DetailPotentialData? model = snapshot.data as DetailPotentialData?;
          return (model != null)
              ? ContainerDataBuilder(
                  data: model,
                  skeletonBuilder: _buildSkeleton(),
                  bodyBuilder: () {
                    if (_bloc.children == null && model.tabConfigs != null) {
                      _bloc.children = [];
                      for (var e in model.tabConfigs!) {
                        switch (e.code) {
                          case leadConfigDeal:
                            _bloc.children!.add(_buildListDeal(e));
                            _bloc.children!
                                .add(SizedBox(height: AppSizes.minPadding / 2));
                            break;
                          case leadConfigCustomerCare:
                            _bloc.children!.add(_buildListCustomerCare(e));
                            _bloc.children!
                                .add(SizedBox(height: AppSizes.minPadding / 2));
                            break;
                          case leadConfigContact:
                            _bloc.children!
                                .add(SizedBox(height: AppSizes.minPadding / 2));
                            _bloc.children!.add(_buildListContact(e));
                            break;
                          case leadConfigNote:
                            _bloc.children!
                                .add(SizedBox(height: AppSizes.minPadding / 2));
                            _bloc.children!.add(_buildLisNote(e));
                            break;
                          case leadConfigFile:
                            _bloc.children!
                                .add(SizedBox(height: AppSizes.minPadding / 2));
                            _bloc.children!.add(_buildListFile(e));
                            break;
                        }
                      }
                    }
                    return Column(
                      children: [
                        if (_bloc.children != null) ..._bloc.children!,
                      ],
                    );
                  },
                )
              : SizedBox();
        });
  }

  Widget _buildSkeleton() {
    return LoadingWidget(
        padding: EdgeInsets.zero,
        child: CustomListView(
          children: List.generate(
              5,
              (index) => CustomSkeleton(
                    height: 60,
                    radius: 4.0,
                  )),
        ));
  }

  Widget _buildListDeal(CustomerDetailConfigModel e) {
    return StreamBuilder(
        stream: _bloc.outputExpandDeal,
        initialData: _bloc.expandDeal,
        builder: (_, snapshot) {
          _bloc.expandDeal = snapshot.data as bool;
          return StreamBuilder(
              stream: _bloc.outputLeadInfoDeal,
              initialData: _bloc.listDealFromLead,
              builder: (context, snapshot) {
                _bloc.listDealFromLead =
                    snapshot.data as List<DetailLeadInfoDealData>;
                return CustomComboBox(
                  onChanged: (event) =>
                      _bloc.onSetExpand(() => _bloc.expandDeal = event),
                  onTapPlus: () async {
                    if (Global.createDeal != null) {
                      var result = await Global.createDeal!(detail!.toJson());
                      if (result != null) {
                        _bloc.allowPop = true;
                        _bloc.getData(widget.customer_lead_code!);
                      }
                    }
                  },
                  onTapList: () {
                    _bloc.onTapListDeal();
                  },
                  title: e.tabNameVi ?? "",
                  isExpand: _bloc.expandDeal,
                  quantity: _bloc.listDealFromLead.length,
                  child: CustomListView(
                    padding: EdgeInsets.only(
                        top: AppSizes.minPadding, bottom: AppSizes.minPadding),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: _bloc.listDealFromLead
                        .map((e) => dealInfomationItem(e))
                        .toList(),
                  ),
                );
              });
        });
  }

  Widget _buildListCustomerCare(CustomerDetailConfigModel e) {
    return StreamBuilder(
        stream: _bloc.outputExpandCustomerCare,
        initialData: _bloc.expandCare,
        builder: (_, snapshot) {
          _bloc.expandCare = snapshot.data as bool;
          return StreamBuilder(
              stream: _bloc.outputCareLead,
              initialData: _bloc.listCareLead,
              builder: (context, snapshot) {
                _bloc.listCareLead = snapshot.data as List<CareLeadData>;
                return CustomComboBox(
                  onChanged: (event) =>
                      _bloc.onSetExpand(() => _bloc.expandCare = event),
                  onTapPlus: () async {
                    if (Global.createCare != null) {
                      var result =
                          await Global.createCare!(_bloc.detail!.toJson());
                      if (result != null) {
                        _bloc.allowPop = true;
                        _bloc.getData(widget.customer_lead_code!);
                      }
                    }
                  },
                  onTapList: () {
                    _bloc.onTapListCustomerCare();
                  },
                  title: e.tabNameVi ?? "Chăm sóc khách hàng",
                  isExpand: _bloc.expandCare,
                  quantity: _bloc.listCareLead.length,
                  child: CustomListView(
                    padding: EdgeInsets.only(
                        top: AppSizes.minPadding, bottom: AppSizes.minPadding),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: _bloc.listCareLead
                        .map((e) => customerCareItem(e))
                        .toList(),
                  ),
                );
              });
        });
  }

  Widget _buildLisNote(CustomerDetailConfigModel e) {
    return StreamBuilder(
        stream: _bloc.outputExpandListNote,
        initialData: _bloc.expandListNote,
        builder: (_, snapshot) {
          _bloc.expandListNote = snapshot.data as bool;
          return StreamBuilder(
              stream: _bloc.outputListNote,
              initialData: _bloc.listNoteData,
              builder: (context, snapshot) {
                _bloc.listNoteData = snapshot.data as List<NoteData>;
                return CustomComboBox(
                  onChanged: (event) =>
                      _bloc.onSetExpand(() => _bloc.expandListNote = event),
                  onTapList: () {
                    _bloc.onTapListNote();
                  },
                  onTapPlus: () {
                    _bloc.onAddNote(() {
                      _bloc.getListNote(context);
                    });
                  },
                  title: e.tabNameVi ?? "Ghi chú",
                  isExpand: _bloc.expandListNote,
                  quantity: _bloc.listNoteData.length,
                  child: CustomListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.minPadding / 2,
                        vertical: AppSizes.minPadding / 2),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(
                        _bloc.listNoteData.length,
                        (index) => noteItem(
                              _bloc.listNoteData[index],
                              index,
                            )).toList(),
                  ),
                );
              });
        });
  }

  Widget _buildListFile(CustomerDetailConfigModel e) {
    return StreamBuilder(
        stream: _bloc.outputExpandListFile,
        initialData: _bloc.expandListFile,
        builder: (_, snapshot) {
          _bloc.expandListFile = snapshot.data as bool;
          return StreamBuilder(
              stream: _bloc.outputDealsFile,
              initialData: _bloc.listLeadsFiles,
              builder: (context, snapshot) {
                _bloc.listLeadsFiles = snapshot.data as List<LeadFilesModel>;
                return CustomComboBox(
                  onChanged: (event) =>
                      _bloc.onSetExpand(() => _bloc.expandListFile = event),
                  onTapPlus: () {
                    _bloc.onAddFile();
                  },
                  onTapList: () {
                    _bloc.onTapListFile();
                  },
                  title: e.tabNameVi ?? "Tập tin",
                  isExpand: _bloc.expandListFile,
                  quantity: _bloc.listLeadsFiles.length,
                  child: CustomListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.minPadding / 2,
                        vertical: AppSizes.minPadding / 2),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: _bloc.listLeadsFiles
                        .map((e) =>
                            _fileItem(e, _bloc.listLeadsFiles.indexOf(e)))
                        .toList(),
                  ),
                );
              });
        });
  }

  Widget _buildListContact(CustomerDetailConfigModel e) {
    return StreamBuilder(
        stream: _bloc.outputExpandListContact,
        initialData: _bloc.expandListContact,
        builder: (_, snapshot) {
          _bloc.expandListContact = snapshot.data as bool;
          return StreamBuilder(
              stream: _bloc.outputContactList,
              initialData: _bloc.listContact,
              builder: (context, snapshot) {
                _bloc.listContact = snapshot.data as List<ContactListData>;
                return CustomComboBox(
                  onChanged: (event) =>
                      _bloc.onSetExpand(() => _bloc.expandListContact = event),
                  title: e.tabNameVi ?? "",
                  isExpand: _bloc.expandListContact,
                  onTapPlus: () {
                    _bloc.onAddContact();
                  },
                  onTapList: () {
                    _bloc.onTapListContact();
                  },
                  quantity: _bloc.listContact.length,
                  child: CustomListView(
                    padding: EdgeInsets.only(
                        top: AppSizes.minPadding, bottom: AppSizes.minPadding),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: _bloc.listContact
                        .map((e) => contactListItem(e))
                        .toList(),
                  ),
                );
              });
        });
  }

  Widget noteItem(NoteData model, int index) {
    String? name, date;

    if (model.createdBy != null) {
      name = model.createdBy ?? "";
      date = model.createdAt ?? "";
    }
    return CustomContainerList(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.minPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.content ?? "",
              style: AppTextStyles.style14BlackWeight600,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: CustomListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Text(
                      name ?? "",
                      style: AppTextStyles.style14HintNormal,
                    ),
                    Text(
                      parseAndFormatDate(date,
                          format: AppFormat.formatDateTime),
                      style: AppTextStyles.style14HintNormal,
                    ),
                  ],
                )),
                SizedBox(
                  width: AppSizes.minPadding,
                ),
                CustomIndex(index: index)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fileItem(LeadFilesModel model, int index) {
    String? name, date;

    if (model.createdBy != null) {
      name = model.createdBy ?? "";
      date = model.createdAt ?? "";
    }
    return GestureDetector(
      onTap: () {
        _bloc.onOpenFile(model.fileName ?? "", model.path);
      },
      child: CustomContainerList(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.minPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          pathToImage(model.path!)!,
                          width: 24,
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Container(
                          child: AutoSizeText(
                            model.fileName!,
                            style: AppTextStyles.style14BlackNormal,
                            minFontSize: 1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Text(
                model.content ?? "",
                style: AppTextStyles.style14BlackWeight600,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: CustomListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      Text(
                        name ?? "",
                        style: AppTextStyles.style14HintNormal,
                      ),
                      Text(
                        parseAndFormatDate(date,
                            format: AppFormat.formatDateTime),
                        style: AppTextStyles.style14HintNormal,
                      ),
                    ],
                  )),
                  SizedBox(
                    width: AppSizes.minPadding,
                  ),
                  CustomIndex(index: index)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listButtonRelevant() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.minPadding),
          child: Row(
            children: [
              Flexible(
                child: CustomButton(
                  style: AppTextStyles.style15WhiteNormal
                      .copyWith(fontWeight: FontWeight.bold),
                  heightButton: AppSizes.sizeOnTap,
                  text: "Chỉnh sửa",
                  ontap: () async {
                    bool? result =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditPotentialCustomer(
                                  detailPotential: detail,
                                )));

                    if (result != null) {
                      _bloc.allowPop = true;
                      _bloc.getData(widget.customer_lead_code!);
                    }
                  },
                ),
              ),
              SizedBox(
                width: AppSizes.minPadding,
              ),
              Flexible(
                child: CustomButton(
                  style: AppTextStyles.style15WhiteNormal
                      .copyWith(fontWeight: FontWeight.bold),
                  heightButton: AppSizes.sizeOnTap,
                  text: AppLocalizations.text(LangKey.discuss),
                  ontap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatScreen(
                              detail: detail,
                            )));
                  },
                ),
              ),
              SizedBox(
                width: AppSizes.minPadding,
              ),
              Flexible(
                child: CustomButton(
                  style: AppTextStyles.style15WhiteNormal
                      .copyWith(fontWeight: FontWeight.bold),
                  heightButton: AppSizes.sizeOnTap,
                  text: "Liên hệ",
                  ontap: () {
                    if (detail?.phone != null && detail?.phone != "") {
                      if (Global.callHotline != null) {
                        Global.callHotline!({
                          "id": detail?.customerLeadId,
                          "code": detail?.customerLeadCode,
                          "avatar": detail?.avatar,
                          "name": detail?.fullName,
                          "phone": detail?.phone,
                          "type": detail?.customerType,
                        });
                      } else {
                        LeadConnection.showMyDialog(
                            context, "Không có số điện thoại");
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(top: 0, left: 0, right: 0, child: Gaps.line(1))
      ],
    );
  }

  Widget _listButtonInfo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.minPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: CustomButton(
                        style: AppTextStyles.style15WhiteNormal
                            .copyWith(fontWeight: FontWeight.bold),
                        heightButton: AppSizes.sizeOnTap,
                        backgroundColor: AppColors.redColor,
                        text: "XÓA LEAD",
                        ontap: () {
                          LeadConnection.showMyDialogWithFunction(context,
                              AppLocalizations.text(LangKey.warningDeleteLead),
                              ontap: () async {
                            DescriptionModelResponse? result =
                                await LeadConnection.deleteLead(
                                    context, detail!.customerLeadCode);
                            Navigator.of(context).pop();
                            if (result != null) {
                              if (result.errorCode == 0) {
                                _bloc.allowPop = true;
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
                        },
                      ),
                    ),
                    SizedBox(
                      width: AppSizes.minPadding,
                    ),
                    Flexible(
                      child: CustomButton(
                        style: AppTextStyles.style15WhiteNormal
                            .copyWith(fontWeight: FontWeight.bold),
                        heightButton: AppSizes.sizeOnTap,
                        text: "CHUYỂN ĐỔI KH",
                        ontap: () async {
                          await _bloc
                              .convertLead(_bloc.detail!.customerLeadId ?? 0)
                              .then((value) {
                            if (value) {
                              CustomNavigator.pop(context, object: true);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizes.minPadding,
                ),
                Row(
                  children: [
                    Flexible(
                      child: CustomButton(
                        style: AppTextStyles.style15WhiteNormal
                            .copyWith(fontWeight: FontWeight.bold),
                        heightButton: AppSizes.sizeOnTap,
                        text: "THÊM DEAL",
                        ontap: () async {
                          if (Global.createDeal != null) {
                            bool? result =
                                await Global.createDeal!(detail!.toJson());
                            if (result != null) {
                              _bloc.allowPop = true;
                              _bloc.getData(widget.customer_lead_code!);
                            }
                          }
                          //
                        },
                      ),
                    ),
                    SizedBox(
                      width: AppSizes.minPadding,
                    ),
                    Flexible(
                      child: CustomButton(
                        style: AppTextStyles.style15WhiteNormal
                            .copyWith(fontWeight: FontWeight.bold),
                        heightButton: AppSizes.sizeOnTap,
                        text: (_bloc.detail?.saleId != null &&
                                _bloc.detail?.saleId != 0)
                            ? "THU HỒI"
                            : "PHÂN CÔNG",
                        ontap: () async {
                          if (detail?.saleId != null && detail?.saleId != 0) {
                            await _bloc
                                .assignRevokeLead(AssignRevokeLeadRequestModel(
                                    customerLeadCode: detail?.customerLeadCode,
                                    saleId: detail?.saleId ?? 0,
                                    timeRevokeLead: detail?.timeRevokeLead ?? 0,
                                    type: "revoke"))
                                .then((value) {
                              if (value) {
                                _bloc.allowPop = true;
                                _bloc.getData(detail?.customerLeadCode ?? "");
                              }
                            });
                          } else {
                            List<WorkListStaffModel>? models =
                                await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PickOneStaffScreen()));
                            if (models != null && models.length > 0) {
                              await _bloc
                                  .assignRevokeLead(
                                      AssignRevokeLeadRequestModel(
                                          customerLeadCode:
                                              detail?.customerLeadCode,
                                          saleId: models[0].staffId,
                                          timeRevokeLead:
                                              detail?.timeRevokeLead ?? 0,
                                          type: "assign"))
                                  .then((value) {
                                if (value) {
                                  _bloc.allowPop = true;
                                  _bloc.getData(detail?.customerLeadCode ?? "");
                                }
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )),
        Positioned(top: 0, left: 0, right: 0, child: Gaps.line(1))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.customerCare != null) {
          Navigator.of(context)
            // ..pop()
            ..pop(true);
        }

        if (_bloc.allowPop) {
          Navigator.of(context).pop(_bloc.allowPop);
        } else {
          Navigator.of(context).pop();
        }
        return _bloc.allowPop;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          // actionsIconTheme: Navigator.of(context).pop(true),
          backgroundColor: AppColors.primaryColor,
          title: Text(
            AppLocalizations.text(LangKey.detailPotential)!,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
            decoration: BoxDecoration(color: AppColors.white),
            child: buildBody()),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        // floatingActionButton: ExpandableDraggableFab(
        //   initialDraggableOffset:
        //       Offset(12, MediaQuery.of(context).size.height * 11 / 14),
        //   initialOpen: false,
        //   curveAnimation: Curves.easeOutSine,
        //   childrenBoxDecoration: BoxDecoration(
        //       color: Colors.black.withOpacity(0.35),
        //       borderRadius: BorderRadius.circular(10.0)),
        //   childrenCount: 4,
        //   distance: 10,
        //   childrenType: ChildrenType.columnChildren,
        //   childrenAlignment: Alignment.centerRight,
        //   childrenInnerMargin: EdgeInsets.all(15.0),
        //   openWidget: Container(
        //       decoration: BoxDecoration(
        //           boxShadow: [
        //             BoxShadow(
        //               offset: Offset(0, 1),
        //               blurRadius: 2,
        //               color: Colors.black.withOpacity(0.3),
        //             )
        //           ],
        //           shape: BoxShape.circle,
        //           color: Color.fromARGB(255, 105, 136, 156)),
        //       width: 60,
        //       height: 60,
        //       child: Image.asset(
        //         Assets.iconFABMenu,
        //         scale: 2.5,
        //       )),
        //   closeWidget: Container(
        //       decoration: BoxDecoration(boxShadow: [
        //         BoxShadow(
        //           offset: Offset(0, 1),
        //           blurRadius: 2,
        //           color: Colors.black.withOpacity(0.3),
        //         )
        //       ], shape: BoxShape.circle, color: Color(0xFF5F5F5F)),
        //       width: 60,
        //       height: 60,
        //       child: Icon(
        //         Icons.clear,
        //         size: 35,
        //         color: Colors.white,
        //       )),
        //   children: [
        //     Column(
        //       children: [
        //         FloatingActionButton(
        //             backgroundColor: Color(0xFFF45E38),
        //             heroTag: "btn0",
        //             onPressed: () async {
        //               if (Global.createDeal != null) {
        //                 bool? result =
        //                     await Global.createDeal!(detail!.toJson() ?? "");
        //                 if (result != null && result) {
        //                   reloadInfoDeal = true;
        //                   getData();
        //                   index = 1;
        //                   selectedTab(1);
        //                 }
        //               }
        //             },
        //             child: Image.asset(
        //               Assets.iconCreateDeal,
        //               scale: 2.5,
        //             )),
        //         SizedBox(
        //           height: 5.0,
        //         ),
        //         Text(AppLocalizations.text(LangKey.createDeal)!,
        //             style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 14.0,
        //                 fontWeight: FontWeight.w400))
        //       ],
        //     ),
        //     Column(
        //       children: [
        //         FloatingActionButton(
        //             backgroundColor: Color(0xFF41AC8D),
        //             heroTag: "btn1",
        //             onPressed: () async {
        //               bool? result = await Navigator.of(context).push(
        //                   MaterialPageRoute(
        //                       builder: (context) =>
        //                           CustomerCarePotential(detail: detail)));

        //               if (result != null && result) {
        //                 _bloc.allowPop = true;
        //                 reloadCSKH = true;
        //                 getData();
        //                 index = 2;
        //                 selectedTab(2);
        //               }
        //             },
        //             child: Image.asset(
        //               Assets.iconCustomerCare,
        //               scale: 2.5,
        //             )),
        //         SizedBox(
        //           height: 5.0,
        //         ),
        //         Text("CSKH",
        //             style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 14.0,
        //                 fontWeight: FontWeight.w400))
        //       ],
        //     ),
        //     Column(
        //       children: [
        //         FloatingActionButton(
        //             backgroundColor: Color(0xFFDD2C00),
        //             heroTag: "btn3",
        //             onPressed: () async {
        //               LeadConnection.showMyDialogWithFunction(context,
        //                   AppLocalizations.text(LangKey.warningDeleteLead),
        //                   ontap: () async {
        //                 DescriptionModelResponse? result =
        //                     await LeadConnection.deleteLead(
        //                         context, detail!.customerLeadCode);

        //                 Navigator.of(context).pop();

        //                 if (result != null) {
        //                   if (result.errorCode == 0) {
        //                     _bloc.allowPop = true;
        //                     print(result.errorDescription);

        //                     await LeadConnection.showMyDialog(
        //                         context, result.errorDescription);

        //                     Navigator.of(context).pop(true);
        //                   } else {
        //                     LeadConnection.showMyDialog(
        //                         context, result.errorDescription);
        //                   }
        //                 }
        //               });
        //               print("iconDelete");
        //             },
        //             child: Image.asset(
        //               Assets.iconDelete,
        //               scale: 2.5,
        //             )),
        //         SizedBox(
        //           height: 5.0,
        //         ),
        //         Text(AppLocalizations.text(LangKey.delete)!,
        //             style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 14.0,
        //                 fontWeight: FontWeight.w400))
        //       ],
        //     ),
        //     Column(
        //       children: [
        //         FloatingActionButton(
        //           heroTag: "btn4",
        //           onPressed: () async {
        //             bool? result =
        //                 await Navigator.of(context).push(MaterialPageRoute(
        //                     builder: (context) => EditPotentialCustomer(
        //                           detailPotential: detail,
        //                         )));

        //             if (result != null) {
        //               if (result) {
        //                 reloadContactList = true;
        //                 _bloc.allowPop = true;
        //                 selectedTab(index!);
        //                 getData();
        //                 ;
        //               }
        //             }

        //             print("iconEdit");
        //           },
        //           backgroundColor: Color(0xFF00BE85),
        //           child: Image.asset(
        //             Assets.iconEdit,
        //             scale: 2.5,
        //           ),
        //         ),
        //         SizedBox(
        //           height: 5.0,
        //         ),
        //         Text(AppLocalizations.text(LangKey.edit)!,
        //             style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 14.0,
        //                 fontWeight: FontWeight.w400))
        //       ],
        //     )
        //   ],
        // ),
      ),
    );
  }
}

class DetailPotentialTabModel {
  String? typeName;
  int? index;
  bool? selected;

  DetailPotentialTabModel({this.typeName, this.index, this.selected});
}
