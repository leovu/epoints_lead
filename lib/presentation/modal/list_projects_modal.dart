import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/request/list_project_model_request.dart';
import 'package:lead_plugin_epoint/model/response/list_project_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_shimer.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';

class ListProjectsModal extends StatefulWidget {
  ListProjectItems? projectSelected = ListProjectItems();
  ListProjectsModal({Key? key, this.projectSelected}) : super(key: key);

  @override
  _ListProjectsModalState createState() => _ListProjectsModalState();
}

class _ListProjectsModalState extends State<ListProjectsModal> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();

  List<ListProjectItems>? listProjectData = [];
  List<ListProjectItems>? listProjectDataDisplay = [];

  ListProjectModelRequest filterModel =
      ListProjectModelRequest(search: "", page: 1);

  int currentPage = 1;
  int nextPage = 2;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getData(false);
    });
  }

  _scrollListener() async {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (this.nextPage != null && this.currentPage < this.nextPage) {
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

  getData(bool loadMore, {int? page}) async {
    keyboardDismissOnTap(context);
    FocusScope.of(context).unfocus();
    ListProjectModelResponse? model = await LeadConnection.getListProject(
        context,
        ListProjectModelRequest(
            search: _searchext.text, page: filterModel.page));
    if (model != null && (model.data?.items?.length ?? 0) > 0) {
      if (!loadMore) {
        listProjectData = [];
        listProjectData = model.data?.items;
        // ignore: null_aware_before_operator
        // if (listProjectData!.length > 0) {
        //   _controller.animateTo(
        //       _controller.position.minScrollExtent,
        //       duration: Duration(seconds: 2),
        //       curve: Curves.fastOutSlowIn,
        //     );
        // }
      } else {
        listProjectData!.addAll(model.data?.items! as Iterable<ListProjectItems>);
      }

      for (int i = 0; i < listProjectData!.length; i++) {
        if ((widget.projectSelected?.manageProjectId ?? 0) ==
            listProjectData![i].manageProjectId) {
          listProjectData![i].selected = true;
        } else {
          listProjectData![i].selected = false;
        }
      }

      listProjectDataDisplay = listProjectData;

      currentPage = model.data?.pageInfo?.currentPage ?? 0;
      nextPage = model.data?.pageInfo?.nextPage ?? 0;
      setState(() {});
    } else {
      listProjectData = [];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF0067AC),
          title: Text(
            AppLocalizations.text(LangKey.chooseProject)!,
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          // leadingWidth: 20.0,
        ),
        body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: _buildBody()));
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
      child: Column(
        children: [
          _buildSearch(),
           Expanded(
                  child: (listProjectData!.length > 0) ? CustomListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _controller,
                  separator: Divider(),
                  children: _listWidget(),
                ) : Container() )
              ,
          (_searchext.text == "" && listProjectData!.length > 0 &&
                      this.nextPage != null &&
                      this.currentPage < this.nextPage ??
                  0 as bool)
              ? Container(
                  height: 20.0,
                  margin: EdgeInsets.only(bottom: 40),
                  child: Center(
                    child: Text(
                      "Load more",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              : Container(),
          (listProjectData != []) ? _buildButton() : Container()
        ],
      ),
    );
  }

  // Widget dataNotFound() {
  //   return CustomListView(
  //       shrinkWrap: true,
  //       padding:
  //           EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
  //       physics: NeverScrollableScrollPhysics(),
  //       separator: Divider(),
  //       children: List.generate(
  //         5,
  //         (index) => Container(
  //           margin: EdgeInsets.only(top: 15.0),
  //           child: CustomShimmer(
  //             child: CustomSkeleton(height: 50, radius: 5.0),
  //           ),
  //         ),
  //       ));
  // }

  List<Widget> _listWidget() {
    return (listProjectDataDisplay != null && listProjectDataDisplay!.length > 0)
        ? List.generate(
            listProjectDataDisplay!.length,
            (index) => _buildItem(listProjectDataDisplay![index], () {
                  selectedStaff(listProjectDataDisplay![index]);
                }))
        : [Container()];
  }

  Widget _buildButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(widget.projectSelected);
      },
      child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              // AppLocalizations.text(LangKey.convertCustomers),
              AppLocalizations.text(LangKey.confirm)!,
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
          )),
    );
  }

  selectedStaff(ListProjectItems item) async {
    if (item.selected!) {
      return;
    }
    try {
      listProjectData!.firstWhere((element) => element.selected!).selected =
          false;
    } catch (_) {}
    item.selected = true;
    widget.projectSelected = item;
    setState(() {});
  }

  Widget _buildItem(ListProjectItems item, GestureTapCallback ontap) {
    return InkWell(
      onTap: ontap as void Function()?,
      child: Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.manageProjectName!,
              style: TextStyle(
                  fontSize: 15.0,
                  color: item.selected!
                      ? AppColors.primaryColor
                      : Color(0xFF040C21),
                  fontWeight:
                      item.selected! ? FontWeight.w700 : FontWeight.w400),
            ),
            item.selected!
                ? Icon(
                    Icons.radio_button_on,
                    color: AppColors.primaryColor,
                    size: 20,
                  )
                : Icon(
                    Icons.radio_button_off,
                    size: 20,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return TextField(
      enabled: true,
      controller: _searchext,
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
        // hintText: AppLocalizations.text(LangKey.filterNameCodePhone),
        hintText: AppLocalizations.text(LangKey.inputSearch),
        hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF8E8E8E)),
        isDense: true,
      ),
      onChanged: (event) {
        searchModel(event);
        print(event.toLowerCase());
        if (_searchext != null) {
          print(_searchext.text);
        }
      },
    );
  }

  searchModel(String value) {
    if (value.isEmpty) {
      listProjectDataDisplay = listProjectData;
      setState(() {});
    } else {
      try {
        List<ListProjectItems> models = listProjectData!.where((model) {
          List<String> search = value.removeAccents().split(" ");
          bool result = true;
          for (String element in search) {
            if (!((model.manageProjectName ?? "")
                .removeAccents()
                .contains(element))) {
              result = false;
              break;
            }
          }
          return result;
        }).toList();
        listProjectDataDisplay = models;
        setState(() {});
      } catch (_) {
        setState(() {});
      }
    }
  }
}
