import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class FilterByCustomerSource extends StatefulWidget {
  List<CustomerOptionSource> customerSources = <CustomerOptionSource>[];
  FilterByCustomerSource({Key key, this.customerSources}) : super(key: key);

  @override
  _FilterByCustomerSourceState createState() => _FilterByCustomerSourceState();
}

class _FilterByCustomerSourceState extends State<FilterByCustomerSource> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();
  List<CustomerOptionSource> customerSources;
  List<CustomerOptionSource> customerSourcesDisplay;

  @override
  void initState() {
    super.initState();
    customerSources = widget.customerSources;
    customerSourcesDisplay = widget.customerSources;
    setState(() {});
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
          backgroundColor: Color(0xFF0067AC),
          title: Text(
            AppLocalizations.text(LangKey.byCustomerSource),
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
          (customerSourcesDisplay != null)
              ? (customerSourcesDisplay.length > 0)
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
              Navigator.of(context).pop(customerSources);
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
    return (customerSourcesDisplay != null && customerSourcesDisplay.length > 0)
        ? List.generate(
            customerSourcesDisplay.length,
            (index) => _buildItem(customerSourcesDisplay[index], () {
                  selectedItem(customerSourcesDisplay[index]);
                }))
        : [CustomDataNotFound()];
  }

  Widget _buildItem(CustomerOptionSource item, Function ontap) {
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
                  item.sourceName,
                  style: TextStyle(
                      fontSize: 15.0,
                      color:
                          item.selected ? AppColors.primaryColor : Colors.black,
                      fontWeight:
                          item.selected ? FontWeight.bold : FontWeight.normal),
                )
              ],
            ),
          ),
          item.selected
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
      customerSourcesDisplay = customerSources;
      setState(() {});
    } else {
      try {
        List<CustomerOptionSource> models = customerSources.where((model) {
          List<String> search = value.removeAccents().split(" ");
          bool result = true;
          for (String element in search) {
            if (!((model.sourceName ?? "").removeAccents().contains(element))) {
              result = false;
              break;
            }
          }
          return result;
        }).toList();
        customerSourcesDisplay = models;
        setState(() {});
      } catch (_) {
        setState(() {});
      }
    }
  }

  selectedItem(CustomerOptionSource item) async {
    item.selected = !item.selected;

    // var event = models.firstWhere((element) => element.name == item.name);

    // if (event != null) {
    //   event.selected = !event.selected;
    // }

    setState(() {
      // widget.tagsData = models;
    });
  }
}
