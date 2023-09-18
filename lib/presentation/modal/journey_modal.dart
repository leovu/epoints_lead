import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/response/get_journey_model_response.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_item_bottom_sheet.dart';

import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_menu_bottom_sheet.dart';

class JourneyModal extends StatefulWidget {
  List<JourneyData>? journeys = <JourneyData>[];
 JourneyModal({ Key? key , this.journeys}) : super(key: key);

  @override
  _JourneyModalState createState() => _JourneyModalState();
}

class _JourneyModalState extends State<JourneyModal> {
  // final ScrollController _controller = ScrollController();

  JourneyData? journeySelected;

  @override
  Widget build(BuildContext context) {
    return CustomMenuBottomSheet(
      title: AppLocalizations.text(LangKey.chooseStatus),
      widget: (widget.journeys!.length > 0) ? CustomListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0.0),
                    children: (widget.journeys ?? [])
                        .asMap()
                        .map((index, element) => MapEntry(
                        index,
                        CustomItemBottomSheet(
                          element?.journeyName ?? "",
                              () => selectedItem( index),
                          isBorder:
                          index < widget.journeys!.length - 1,
                          isSelected: element.selected,
                        )))
                        .values
                        .toList(),
                  ) : CustomDataNotFound(),
      haveBnConfirm: false,
      
    );
  }

  // List<Widget> _listWidget() {
  //   return (widget.journeys != null && widget.journeys?.length > 0) ? List.generate(
  //       widget.journeys.length,
  //       (index) => _buildItem(
  //               widget.journeys[index].journeyName, widget.journeys[index].selected,
  //               () {
  //             selectedItem(index);
  //           })) : [CustomDataNotFound()];
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
  //                 fontSize: 18.0,
  //                 color: selected ? Colors.orange : Colors.black,
  //                 fontWeight: FontWeight.normal),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  selectedItem(int index) async {
    List<JourneyData> models = widget.journeys!;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {
      Navigator.of(context).pop(models[index]);
    });
  }
}