import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/response/get_status_work_response_model.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_item_bottom_sheet.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_menu_bottom_sheet.dart';

class StatusWorkModal extends StatefulWidget {
  List<GetStatusWorkData>? statusWorkData = [];
 StatusWorkModal({ Key? key, this.statusWorkData }) : super(key: key);

  @override
  _StatusWorkModalState createState() => _StatusWorkModalState();
}

class _StatusWorkModalState extends State<StatusWorkModal> {
  @override
  Widget build(BuildContext context) {
    return CustomMenuBottomSheet(
      title: AppLocalizations.text(LangKey.status),
      widget: (widget.statusWorkData!.length > 0) ? CustomListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0.0),
                    children: (widget.statusWorkData ?? [])
                        .asMap()
                        .map((index, element) => MapEntry(
                        index,
                        CustomItemBottomSheet(
                          element?.manageStatusName ?? "",
                              () => selectedItem( index),
                          isBorder:
                          index < widget.statusWorkData!.length - 1,
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
  //       widget.sources.length,
  //       (index) => _buildItem(
  //               widget.sources[index].sourceName, widget.sources[index].selected,
  //               () {
  //             selectedItem(index);
  //           }));
  // }

  // Widget _buildItem(String title, bool selected, GestureTapCallback ontap) {
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
    List<GetStatusWorkData> models = widget.statusWorkData!;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {
      Navigator.of(context).pop(models[index]);
    });
  }
}