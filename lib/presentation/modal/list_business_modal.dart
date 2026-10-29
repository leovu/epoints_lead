import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modal/create_new_business_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';

import 'package:lead_plugin_epoint/widget/custom_avatar.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class ListBusinessModal extends StatefulWidget {
  const ListBusinessModal({Key? key}) : super(key: key);

  @override
  _ListBusinessModalState createState() => _ListBusinessModalState();
}

class _ListBusinessModalState extends State<ListBusinessModal> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();
  late GetAllocatorModelReponse _model;
  // List<AllocatorData> allocators = <AllocatorData>[];
  // GetAllocatorModelReponse dataAllocator;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      LeadConnection.showLoading(context);
      var data = await LeadConnection.getAllocator(context);
      if (data != null) {
        // dataAllocator = data;
        // allocators = data.data;

        //  _model = GetAllocatorModelReponse(
        // data: (allocators ?? <AllocatorData>[])
        //     .map((e) => AllocatorData.fromJson(e.toJson()))
        //     .toList());
      }

      Navigator.of(context).pop();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppGlass.background(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: AppGlass.headerOverlayStyle,
        leading: AppGlass.backButton(context),
        leadingWidth: 60.0,
        iconTheme: const IconThemeData(
          color: AppGlass.headerForeground,
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: AppGlass.headerShape,
        flexibleSpace: Container(decoration: AppGlass.header()),
        title: Text(
          AppLocalizations.text(LangKey.listBusiness)!,
          style: const TextStyle(
              color: AppGlass.headerForeground,
              fontSize: 18.0,
              fontWeight: FontWeight.w600),
        ),
        // leadingWidth: 20.0,
      ),
      body: Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: _buildBody()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () async {
          var result = await showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CreateNewBusinessModal());
              });
          if (result != null) {}
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 50,
        ),
      ),
    ));
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
      child: Column(
        children: [
          _buildSearch(),
          // (allocators != null)
          Expanded(
              child: CustomListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 19.0, bottom: 16.0),
            physics: AlwaysScrollableScrollPhysics(),
            controller: _controller,
            separatorPadding: 5.0,
            // separator: Divider(color: AppColors.primaryColorMix),
            // children: (_model != null) ? (_model.data.length > 0) ? _listWidget() : [CustomDataNotFound()] : [Container()],
            children: _listWidget(),
          )),
          // : Container(),
        ],
      ),
    );
  }

  List<Widget> _listWidget() {
    return List.generate(
        // _model.data.length,
        15,
        (index) => _buildBusinessItem(() {
              // selectedStaff(index);
            }));
  }

  Widget _buildBusinessItem(GestureTapCallback ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        height: 80.0,
        decoration: BoxDecoration(
            boxShadow: AppGlass.shadow,
            gradient: AppGlass.cardGradient,
            border: Border.all(
                width: 1.0,
                color: AppColors.secondaryColorMix,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(AppRadius.md)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  _buildAvatar("Doanh nghiep 01"),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Doanh nghiệp 01",
                      style: TextStyle(
                          fontSize: 16.0,
                          // color: item.selected ? Colors.orange : AppColors.textTitleColor,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: AppColors.primaryColor,
              size: 30.0,
            )
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
          //     BorderSide(width: 1, color: AppColors.secondaryColorMix),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        // hintText: AppLocalizations.text(LangKey.filterNameCodePhone),
        hintText: AppLocalizations.text(LangKey.inputSearch),
        suffixIcon: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset(
            Assets.iconSearch,
          ),
        ),
        suffixIconConstraints: BoxConstraints(maxHeight: 40.0, maxWidth: 40.0),
        isDense: true,
      ),
      onChanged: (event) {
        // searchModel(allocators,event);
      },
    );
  }

  Widget _buildAvatar(String name) {
    return Container(
      width: 50.0,
      height: 50.0,
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // color: Color.fromARGB(255, 243, 245, 247),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: CustomAvatar(
          color: AppColors.primaryColor,
          name: name,
          textSize: 22.0,
        ),
      ),
    );
  }

  searchModel(List<AllocatorData> model, String value) {
    if (value.isEmpty) {
      // _model.data = allocators;
      setState(() {});
    } else {
      try {
        List<AllocatorData> models = model.where((model) {
          List<String> search = value.removeAccents().split(" ");
          bool result = true;
          for (String element in search) {
            if (!((model.fullName ?? "").removeAccents().contains(element))) {
              result = false;
              break;
            }
          }
          return result;
        }).toList();
        _model.data = models;
        setState(() {});
      } catch (_) {
        setState(() {});
      }
    }
  }
}

extension NumberParsing on String {
  double? tryParseDouble({bool isRound = false}) {
    if (this == "null") {
      return 0.0;
    }
    String param = this.toString().replaceAll(",", "");
    double? val = double.tryParse(param);
    return val == null
        ? 0.0
        : (isRound ? double.tryParse(val.toStringAsFixed(2)) : val);
  }
}
