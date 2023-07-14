import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/customer_type.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';

class FilterByCustomerType extends StatefulWidget {
  List<CustomerTypeModel>? customerTypeData = <CustomerTypeModel>[];
  FilterByCustomerType({Key? key, this.customerTypeData}) : super(key: key);

  @override
  _FilterByCustomerTypeState createState() => _FilterByCustomerTypeState();
}

class _FilterByCustomerTypeState extends State<FilterByCustomerType> {

  Widget build(BuildContext context) {
    return (widget.customerTypeData != null)
        ? Container(
            margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Wrap(
              children: List.generate(
                  widget.customerTypeData!.length,
                  (index) => _optionItem(
                          widget.customerTypeData![index].customerTypeName,
                          widget.customerTypeData![index].selected!, () {
                        selectedItem(index);
                      })),
              spacing: 20,
              runSpacing: 20,
            ),
          )
        : Container();
  }

  Widget _optionItem(String? name, bool selected, Function ontap) {
    return InkWell(
      onTap: ontap as void Function()?,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          selected
              ? Container(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  height: 40,
                  // width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                          width: 1.0,
                          color: Colors.blue,
                          style: BorderStyle.solid)),
                  child: Center(
                    child: Text(
                      name!,
                      style: TextStyle(
                          color: Color(0xFF0067AC),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  height: 40,
                  // width: 100,
                  decoration: BoxDecoration(
                      color: Color(0xFFEAEAEA),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(
                      name!,
                      style: TextStyle(color: Color(0xFF8E8E8E)),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  selectedItem(int index) async {
    List<CustomerTypeModel> models = widget.customerTypeData!;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {});
  }
}