import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/response/list_business_areas_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modal/create_new_business_area_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class BusinessAreasModal extends StatefulWidget {
  List<ListBusinessAreasItem>? listBusinessData = [];
  BusinessAreasModal({Key? key, this.listBusinessData}) : super(key: key);

  @override
  _BusinessAreasModalState createState() => _BusinessAreasModalState();
}

class _BusinessAreasModalState extends State<BusinessAreasModal> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();
  List<ListBusinessAreasItem>? listBusinessData;
  List<ListBusinessAreasItem>? listBusinessDataDisplay;

  @override
  void initState() {
    super.initState();
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
    FocusScope.of(context).unfocus();
    LeadConnection.showLoading(context);

    if (widget.listBusinessData!.length == 0) {
      ListBusinessAreasModelResponse? model =
          await LeadConnection.getListBusinessAreas(context);
     
      if (model != null) {
        listBusinessData = model.data;
      }
    } else {
      ListBusinessAreasModelResponse? model =
          await LeadConnection.getListBusinessAreas(context);
      if (model != null) {
        listBusinessData = widget.listBusinessData;
      }
    }
    
    listBusinessDataDisplay = listBusinessData;
     Navigator.of(context).pop();
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
            AppLocalizations.text(LangKey.chooseBusinessAreas)!,
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: () async {
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
                          child: CreateNewBusinessAreaModal());
                      });
                  if (result != null && result) {
                    getData();
                    }
                },
                child: Icon(Icons.add, size: 30,),
              ),
            )
          ],
          // leadingWidth: 20.0,
        ),
        body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: _buildBody()),);
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
      child: Column(
        children: [
          _buildSearch(),
          (listBusinessData != null)
              ? (listBusinessData!.length > 0)
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
            onTap: () {
              Navigator.of(context).pop(listBusinessData);
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
    return (listBusinessDataDisplay != null)
        ? (listBusinessDataDisplay!.length > 0) ? List.generate(
            listBusinessDataDisplay!.length,
            (index) => _buildItem(listBusinessDataDisplay![index], () {
                  selectedItem(listBusinessDataDisplay![index]);
                }))
        : [CustomDataNotFound()] : Expanded(child: Container()) as List<Widget>;
  }

  Widget _buildItem(ListBusinessAreasItem item, Function ontap) {
    return InkWell(
      onTap: ontap as void Function()?,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40,
            child: Row(
              children: [
                Text(
                  item.businessName!,
                  style: TextStyle(
                      fontSize: 15.0,
                      color:
                          item.selected! ? AppColors.primaryColor : Colors.black,
                      fontWeight:
                          item.selected! ? FontWeight.bold : FontWeight.normal),
                )
              ],
            ),
          ),
          item.selected!
              ? Icon(
                  Icons.radio_button_checked_rounded,
                  color: AppColors.primaryColor,
                )
              : Icon(
                  Icons.radio_button_off,
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
        searchModel( event);
        print(event.toLowerCase());
        if (_searchext != null) {
          print(_searchext.text);
        }
      },
    );
  }

  searchModel( String value) {
    if (value.isEmpty) {
      listBusinessDataDisplay = listBusinessData;
      setState(() {});
    } else {
      try {
        List<ListBusinessAreasItem> models = listBusinessData!.where((model) {
          List<String> search = value.removeAccents().split(" ");
          bool result = true;
          for (String element in search) {
            if (!((model.businessName ?? "")
                .removeAccents()
                .contains(element))) {
              result = false;
              break;
            }
          }
          return result;
        }).toList();
        listBusinessDataDisplay = models;
        setState(() {});
      } catch (_) {
        setState(() {});
      }
    }
  }

  selectedItem(ListBusinessAreasItem item) async {

if (item.selected!) {
      return;
    }
    try {
      listBusinessData!.firstWhere((element) => element.selected!).selected =
          false;
    } catch (_) {}
    item.selected = true;
    setState(() {});
  }


  // if (!item.selected) {
  //     //   return;
  //     // }
  //     try {
  //       listBusinessData.firstWhere((element) => element.selected).selected =
  //           false;
  //     } catch (_) {}
  //     item.selected = true;
  //     setState(() {});
  //   } else {
  //     item.selected = false;
  //     setState(() {});
  //   }
}
