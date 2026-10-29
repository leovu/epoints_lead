import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/response/get_pipeline_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class FilterByPipeline extends StatefulWidget {
  List<PipelineData>? pipeLineData = <PipelineData>[];
  FilterByPipeline(this.pipeLineData);

  @override
  _FilterByPipelineState createState() => _FilterByPipelineState();
}

class _FilterByPipelineState extends State<FilterByPipeline> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();
  List<PipelineData>? pipeLineData;
  List<PipelineData>? pipeLineDataDisplay;

  @override
  void initState() {
    super.initState();
    pipeLineData = widget.pipeLineData;
    pipeLineDataDisplay = widget.pipeLineData;
    setState(() {});
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
                AppLocalizations.text(LangKey.choosePipeline)!,
                style: const TextStyle(
                    color: AppGlass.headerForeground,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
            body: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: _buildBody())));
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
      child: Column(
        children: [
          _buildSearch(),
          (pipeLineDataDisplay != null)
              ? (pipeLineDataDisplay!.length > 0)
                  ? Expanded(
                      child: CustomListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _controller,
                      separator: Divider(color: AppColors.primaryColorMix),
                      children: _listWidget(),
                    ))
                  : Expanded(child: CustomDataNotFound())
              : Expanded(child: Container()),
          CustomButton(
            text: AppLocalizations.text(LangKey.confirm),
            ontap: () {
              Navigator.of(context).pop(pipeLineData);
            },
          ),
          Container(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  List<Widget> _listWidget() {
    return (pipeLineDataDisplay != null && pipeLineDataDisplay!.length > 0)
        ? List.generate(
            pipeLineDataDisplay!.length,
            (index) => _buildItem(pipeLineDataDisplay![index], () {
                  selectedItem(pipeLineDataDisplay![index]);
                }))
        : [CustomDataNotFound()];
  }

  Widget _buildItem(PipelineData item, GestureTapCallback ontap) {
    return InkWell(
      onTap: ontap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40,
            child: Row(
              children: [
                Text(
                  item.pipelineName!,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: item.selected!
                          ? AppColors.primaryColor
                          : AppColors.textTitleColor,
                      fontWeight:
                          item.selected! ? FontWeight.bold : FontWeight.normal),
                )
              ],
            ),
          ),
          item.selected!
              ? Icon(
                  Icons.check_box,
                  color: AppColors.primaryColor,
                )
              : Icon(
                  Icons.check_box_outline_blank,
                  color: Color.fromARGB(255, 108, 102, 94),
                )
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return TextField(
      enabled: true,
      controller: _searchext,
      focusNode: _fonusNode,
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
        isDense: true,
      ),
      onChanged: (event) {
        searchModel(event);
      },
    );
  }

  searchModel(String value) {
    if (value.isEmpty) {
      pipeLineDataDisplay = pipeLineData;
      setState(() {});
    } else {
      try {
        List<PipelineData> models = pipeLineData!.where((model) {
          List<String> search = value.removeAccents().split(" ");
          bool result = true;
          for (String element in search) {
            if (!((model.pipelineName ?? "")
                .removeAccents()
                .contains(element))) {
              result = false;
              break;
            }
          }
          return result;
        }).toList();
        pipeLineDataDisplay = models;
        setState(() {});
      } catch (_) {
        setState(() {});
      }
    }
  }

  selectedItem(PipelineData item) async {
    item.selected = !item.selected!;
    setState(() {});
  }
}
