import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/response/get_status_work_response_model.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class FilterByWorkStatus extends StatefulWidget {
  List<GetStatusWorkData>? statusWorkData;
   FilterByWorkStatus({ Key? key, this.statusWorkData }) : super(key: key);

  @override
  _FilterByWorkStatusState createState() => _FilterByWorkStatusState();
}

class _FilterByWorkStatusState extends State<FilterByWorkStatus> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();
  List<GetStatusWorkData>? statusWorkData;
  List<GetStatusWorkData>? statusWorkDataDisplay;


  @override
  void initState() {
    super.initState();
    statusWorkData = widget.statusWorkData;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      
      getData();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    super.dispose();
  }

  getData() async {
    keyboardDismissOnTap(context);

    if (statusWorkData == null || statusWorkData!.length == 0) {
              LeadConnection.showLoading(context);
              var statusWorkModel = await LeadConnection.getStatusWork(context);

              Navigator.of(context).pop();
              if (statusWorkModel != null) {
                statusWorkData = statusWorkModel.data;
                statusWorkDataDisplay = statusWorkData;
              }
            } else {
              statusWorkDataDisplay = statusWorkData;
            }

   
      setState(() {});
    // }
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
            AppLocalizations.text(LangKey.byWorkStatus)!,
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
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
          (statusWorkDataDisplay != null)
              ? (statusWorkDataDisplay!.length > 0)
                  ? Expanded(
                      child: CustomListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _controller,
                      separator: Divider(),
                      children: _listWidget(),
                    ))
                  : Expanded(child: CustomDataNotFound())
              : Expanded(child: Container()),
          CustomButton(
            text: AppLocalizations.text(LangKey.confirm),
            ontap: () {
              Navigator.of(context).pop(statusWorkData);
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
    return (statusWorkDataDisplay != null && statusWorkDataDisplay!.length > 0)
        ? List.generate(
            statusWorkDataDisplay!.length,
            (index) => _buildItem(statusWorkDataDisplay![index], () {
                  selectedItem(statusWorkDataDisplay![index]);
                }))
        : [CustomDataNotFound()];
  }

  Widget _buildItem(GetStatusWorkData item, GestureTapCallback ontap) {
    return InkWell(
      onTap: ontap ,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40,
            child: Row(
              children: [
                Text(
                  item.manageStatusName!,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: item.selected! ? AppColors.primaryColor : Colors.black,
                      fontWeight:item.selected! ? FontWeight.bold : FontWeight.normal),
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
          //     BorderSide(width: 1, color: Color.fromARGB(255, 21, 230, 129)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Color(0xFFB8BFC9)),
        ),
        // hintText: AppLocalizations.text(LangKey.filterNameCodePhone),
        hintText: AppLocalizations.text(LangKey.inputSearch),
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
      statusWorkDataDisplay = statusWorkData;
      setState(() {});
    } else {
      try {
        List<GetStatusWorkData> models = statusWorkData!.where((model) {
          List<String> search = value.removeAccents().split(" ");
          bool result = true;
          for (String element in search) {
            if (!((model.manageStatusName ?? "").removeAccents().contains(element))) {
              result = false;
              break;
            }
          }
          return result;
        }).toList();
        statusWorkDataDisplay = models;
        setState(() {});
      } catch (_) {
        setState(() {});
      }
    }
  }

  selectedItem(GetStatusWorkData item) async {
    item.selected = !item.selected!;

    // var event = models.firstWhere((element) => element.name == item.name);

    // if (event != null) {
    //   event.selected = !event.selected;
    // }

    setState(() {
      // widget.tagsData = models;
    });
  }
}