import 'package:auto_size_text_plus/auto_size_text_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_direct_call_plus/flutter_direct_call.dart';
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
import 'package:lead_plugin_epoint/utils/custom_app_format.dart';
import 'package:lead_plugin_epoint/utils/global.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/utils/visibility_api_widget_name.dart';
import 'package:lead_plugin_epoint/widget/container_data_builder.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar_with_url.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_file_view.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:lead_plugin_epoint/widget/custom_row_image_content_widget.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';
import 'package:lead_plugin_epoint/widget/widget.dart';

part 'widgets/general_information_tab.dart';
part 'widgets/relevant_tab.dart';

// ignore: must_be_immutable
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
  late PageController _pageController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _bloc = DetailPotentialCustomerBloc(context);

    index = widget.indexTab;
    for (int i = 0; i < tabPotentials.length; i++) {
      if (index == tabPotentials[i].index) {
        tabPotentials[i].selected = true;
      } else {
        tabPotentials[i].selected = false;
      }
    }

    _pageController = PageController(initialPage: index ?? 0);

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
    _pageController.dispose();
    super.dispose();
  }

  void _goToTab(int i) {
    index = i;
    selectedTab(i);
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        i,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
    return PageView(
      controller: _pageController,
      onPageChanged: (i) {
        index = i;
        selectedTab(i);
      },
      children: [
        _listInfomationRelevant(),
        generalInfomationV2(),
      ],
    );
  }

  Widget buildListOption() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: option(
                tabPotentials[0].typeName!, tabPotentials[0].selected!, 100,
                () => _goToTab(0)),
          ),
          Expanded(
            child: option(
                tabPotentials[1].typeName!, tabPotentials[1].selected!, 100,
                () => _goToTab(1)),
          ),
        ],
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

  _callPhone(String phone) {
    FlutterDirectCall.makeDirectCall(phone);
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
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
      ),
      canPop: false,
      onPopInvokedWithResult: (event, _) {
        if (!event) {
          if (widget.customerCare != null) {
            Navigator.of(context)
              .pop(true);
          }

          if (_bloc.allowPop) {
            Navigator.of(context).pop(_bloc.allowPop);
          } else {
            Navigator.of(context).pop();
          }
        }
      },
    );
  }
}

class DetailPotentialTabModel {
  String? typeName;
  int? index;
  bool? selected;

  DetailPotentialTabModel({this.typeName, this.index, this.selected});
}
