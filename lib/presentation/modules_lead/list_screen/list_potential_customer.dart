import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/filter_screen_model.dart';
import 'package:lead_plugin_epoint/model/request/list_customer_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/model/response/list_customer_lead_model_response.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/create_potential_customer.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_potential_customer.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/detail_potential_customer.dart';
import 'package:lead_plugin_epoint/utils/global.dart';
import 'package:lead_plugin_epoint/utils/visibility_api_widget_name.dart';
import 'package:lead_plugin_epoint/widget/container_data_builder.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_dialog.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';
import 'package:lead_plugin_epoint/widget/widget.dart';
import 'package:rxdart/subjects.dart';
import 'dart:ui' as ui;

import '../../../widget/custom_avatar_with_url.dart';

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
    AppLocalizations.text(LangKey.useExcel)!,
    AppLocalizations.text(LangKey.timekeeping)!,
    "Chathub",
    AppLocalizations.text(LangKey.jobManagement)!,
    AppLocalizations.text(LangKey.timekeeping)!,
    "QLCV"
  ];

  final streamModel = BehaviorSubject<List<ListCustomLeadItems>?>();

  int currentPage = 1;
  int nextPage = 1;

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
    isConvert: "0",
    createdAt: "",
    allocationDate: "",
  );

  FilterScreenModel filterScreenModel = FilterScreenModel();

  @override
  void initState() {
    super.initState();

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
    LeadConnection.showLoading(context);
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
            careHistory: filterModel!.careHistory,
            pipelineId: filterModel!.pipelineId,
            journeyId: filterModel!.journeyId));
     Navigator.of(context).pop();

    if (model != null) {
      models = [];
      if (!loadMore) {
        items = model.data?.items ?? [];
        if (_controller.hasClients) {
          _controller.animateTo(
            _controller.position.minScrollExtent,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
          );
        }
      } else {
        items!.addAll(model.data?.items as Iterable<ListCustomLeadItems>);
      }
      currentPage = model.data?.pageInfo?.currentPage ?? 1;
      nextPage = model.data?.pageInfo?.nextPage ?? 1;
      streamModel.set(items);
    } else {
      print('!!!!!!!!!!!!!!!!!!!@#');
      items = [];
      streamModel.set([]);
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
        centerTitle: true,
        title: Text(
          AppLocalizations.text(LangKey.listPotential)!,
          style: TextStyle(color: Colors.white, fontSize: 18.0),
          textAlign: TextAlign.center,
        ),
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
              //  else {
              //   filterModel!.page = 1;
              //   getData(false);
              // }
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
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Column(
        children: [
          _buildSearch(),
          Expanded(
            child: StreamBuilder(
              stream: streamModel.output,
              builder: (context, snapshot) {
                items = snapshot.data as List<ListCustomLeadItems>?;
                return ContainerDataBuilder(
                  data: items,
                  skeletonBuilder: _buildSkeleton(),
                  emptyBuilder: CustomEmptyData(),
                  onRefresh: () async {
                    filterModel!.page = 1;
                    getData(false);
                  },
                  bodyBuilder: () => CustomListView(
                    padding: const EdgeInsets.only(
                        top: 30.0, bottom: 10.0, left: 10.0, right: 10.0),
                    onLoadmore: () async {
                      if (currentPage < nextPage) {
                        filterModel!.page = currentPage + 1;
                        getData(true);
                      }
                    },
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: false,
                    controller: _controller,
                    children: [
                      Column(
                        children: items!
                            .map((e) => _LeadCard(
                                  item: e,
                                  onRefresh: () => getData(false),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return LoadingWidget(
        padding: EdgeInsets.zero,
        child: CustomListView(
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          children: List.generate(
              10,
              (index) => CustomSkeleton(
                    height: 200,
                    radius: 4.0,
                  )),
        ));
  }

  Widget _buildSearch() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextField(
          enabled: true,
          controller: _searchtext,
          focusNode: _fonusNode,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.all(12.0),
            border: OutlineInputBorder(
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
          onSubmitted: (event) async {
            filterModel!.page = 1;
            getData(false);
          }),
    );
  }
}

// ---------------------------------------------------------------------------
// Card widget
// ---------------------------------------------------------------------------

class _LeadCard extends StatelessWidget {
  final ListCustomLeadItems item;
  final VoidCallback onRefresh;

  const _LeadCard({required this.item, required this.onRefresh});

  Future<void> _navigateToDetail(BuildContext context) async {
    bool? result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DetailPotentialCustomer(
              customer_lead_code: item.customerLeadCode,
              indexTab: 0,
              typeCustomer: item.customerType,
            )));
    if (result != null && result) onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 32.0),
          child: InkWell(
            onTap: () => _navigateToDetail(context),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: const Color(0xFFC3C8D3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LeadCardHeader(item: item),
                  _LeadCardInfoRow(
                    item: item,
                    onNavigate: () => _navigateToDetail(context),
                    onCall: () {
                      if (Global.callHotline != null && item.phone != '') {
                        Global.callHotline!({
                          'id': item.customerLeadId,
                          'code': item.customerLeadCode,
                          'avatar': item.avatar,
                          'name': item.leadFullName,
                          'phone': item.phone,
                          'type': item.customerType,
                        });
                      } else {
                        LeadConnection.showMyDialog(context,
                            AppLocalizations.text(LangKey.noPhoneNumber));
                      }
                    },
                  ),
                  if (item.tag!.isNotEmpty) _LeadCardTags(tags: item.tag!),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: -10,
          child: CustomAvatarWithURL(
            backgroundColor: const Color(0xFFEEB132),
            url: item.avatar ?? '',
            name: item.leadFullName,
            size: 60.0,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Header: source - name (bold) + journey badge + phone
// ---------------------------------------------------------------------------

class _LeadCardHeader extends StatelessWidget {
  final ListCustomLeadItems item;

  const _LeadCardHeader({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 4.0),
      margin: const EdgeInsets.only(left: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: item.customerSourceName ?? '',
                    style: const TextStyle(
                      height: 1.5,
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                    children: [
                      TextSpan(
                        text: (item.customerSourceName != null &&
                                item.customerSourceName != '')
                            ? ' - ${item.leadFullName!}'
                            : item.leadFullName!,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 5.0)),
                      WidgetSpan(
                        alignment: ui.PlaceholderAlignment.top,
                        child: _LeadJourneyBadge(name: item.journeyName),
                      ),
                    ],
                  ),
                ),
              ),
              _LeadActionIcon(
                color: AppColors.bluePrimary,
                icon: Icons.notifications,
                number: item.relatedWork ?? 0,
              ),
            ],
          ),
          Text(
            hidePhone(item.phone ?? '',
                checkVisibilityKey(VisibilityWidgetName.CM000004)),
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info row: left = staff / lastCare / pipeline, right = action icons
// ---------------------------------------------------------------------------

class _LeadCardInfoRow extends StatelessWidget {
  final ListCustomLeadItems item;
  final VoidCallback onNavigate;
  final VoidCallback onCall;

  const _LeadCardInfoRow({
    required this.item,
    required this.onNavigate,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0, top: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LeadInfoTile(
                    iconAsset: Assets.iconName,
                    title: item.staffFullName ?? ''),
                _LeadLastCareTile(
                    dateLastCare: item.dateLastCare, diffDay: item.diffDay),
                _LeadInfoTile(
                    iconAsset: Assets.iconChance,
                    title: item.pipelineName ?? ''),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // if (checkVisibilityKey(VisibilityWidgetName.CM000008))
              //   _LeadCallIcon(onTap: onCall),
              // _LeadActionIcon(
              //   icon: Icons.calendar_month_outlined,
              //   color: const Color(0xFF26A7AD),
              //   number: item.relatedWork ?? 0,
              //   onTap: onNavigate,
              // ),
              // _LeadActionIcon(
              //   icon: Icons.meeting_room_outlined,
              //   color: const Color(0xFFDD2C00),
              //   number: item.appointment ?? 0,
              //   onTap: onNavigate,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tags row
// ---------------------------------------------------------------------------

class _LeadCardTags extends StatelessWidget {
  final List<Tag> tags;

  const _LeadCardTags({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: tags.map((t) => _LeadTagChip(tag: t)).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small reusable widgets
// ---------------------------------------------------------------------------

class _LeadJourneyBadge extends StatelessWidget {
  final String? name;

  const _LeadJourneyBadge({this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF3AEDB6),
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.all(3.0),
      child: Text(
        name ?? 'N/A',
        style: const TextStyle(
          color: Color.fromARGB(255, 3, 68, 48),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

class _LeadInfoTile extends StatelessWidget {
  final String iconAsset;
  final String title;

  const _LeadInfoTile({required this.iconAsset, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            height: 15.0,
            width: 15.0,
            child: Image.asset(iconAsset),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeadLastCareTile extends StatelessWidget {
  final String? dateLastCare;
  final dynamic diffDay;

  const _LeadLastCareTile({this.dateLastCare, this.diffDay});

  @override
  Widget build(BuildContext context) {
    if (dateLastCare == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            height: 15.0,
            width: 15.0,
            child: Image.asset(Assets.iconInteraction),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$dateLastCare ',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  TextSpan(
                    text:
                        '($diffDay ${AppLocalizations.text(LangKey.day)?.toLowerCase()})',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeadTagChip extends StatelessWidget {
  final Tag tag;

  const _LeadTagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0x420067AC),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 8.0,
            width: 8.0,
            margin: const EdgeInsets.only(right: 5.0),
            decoration: BoxDecoration(
              color: const Color(0x790067AC),
              borderRadius: BorderRadius.circular(1000.0),
            ),
          ),
          Text(
            tag.tagName!,
            style: const TextStyle(
              color: Color(0xFF0067AC),
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeadCallIcon extends StatelessWidget {
  final VoidCallback? onTap;

  const _LeadCallIcon({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: const Padding(
        padding: EdgeInsets.all(6.0),
        child: Icon(Icons.phone, color: Color(0xFF06A605), size: 24),
      ),
    );
  }
}

class _LeadActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int number;
  final VoidCallback? onTap;

  const _LeadActionIcon({
    required this.icon,
    required this.color,
    required this.number,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: color, size: 24),
            if (number > 0)
              Positioned(
                left: 14,
                bottom: 14,
                child: Container(
                  width: number > 9 ? 22 : 18,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xFFF45E38),
                  ),
                  child: Center(
                    child: Text(
                      number > 9 ? '9+' : '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
