import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/customer_type.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_item_bottom_sheet.dart';

import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_menu_bottom_sheet.dart';

class CustomerTypeModal extends StatefulWidget {
   List<CustomerTypeModel> customerTypeData = <CustomerTypeModel>[];
 CustomerTypeModal({ Key key, this.customerTypeData }) : super(key: key);

  @override
  _CustomerTypeModalState createState() => _CustomerTypeModalState();
}

class _CustomerTypeModalState extends State<CustomerTypeModal> {

  @override
  Widget build(BuildContext context) {
    return CustomMenuBottomSheet(
      title: AppLocalizations.text(LangKey.customerStyle),
      widget: (widget.customerTypeData.length > 0) ? CustomListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0.0),
                    children: (widget.customerTypeData ?? [])
                        .asMap()
                        .map((index, element) => MapEntry(
                        index,
                        CustomItemBottomSheet(
                          element?.customerTypeName ?? "",
                              () => selectedItem( index),
                          isBorder:
                          index < widget.customerTypeData.length - 1,
                          isSelected: element.selected,
                        )))
                        .values
                        .toList(),
                  ) : CustomDataNotFound(),
      haveBnConfirm: false,
      
    );
  }

  // List<Widget> _listWidget() {
  //   return List.generate(
  //       widget.customerTypeData.length,
  //       (index) => _buildItem(
  //               widget.customerTypeData[index].customerTypeName, widget.customerTypeData[index].selected,
  //               () {
  //             selectedItem(index);
  //           }));
  // }

  // Widget _buildItem(String title, bool selected, Function ontap) {
  //   return InkWell(
  //     onTap: ontap,
  //     child: Container(
  //       height: 40,
  //       child: Row(
  //         children: [
  //           Text(
  //             title,
  //             style: TextStyle(
  //                 fontSize: 17.0,
  //                 color: selected ? Colors.orange : Colors.black,
  //                 fontWeight: FontWeight.normal),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  selectedItem(int index) async {
    List<CustomerTypeModel> models = widget.customerTypeData;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {
      Navigator.of(context).pop(models[index]);
    });
  }
}