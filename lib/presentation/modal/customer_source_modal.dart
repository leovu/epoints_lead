import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_item_bottom_sheet.dart';

import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_menu_bottom_sheet.dart';

class CustomerSourceModal extends StatefulWidget {
  List<CustomerOptionSource>? sources = <CustomerOptionSource>[];
   CustomerSourceModal({ Key? key , this.sources}) : super(key: key);

  @override
  _CustomerSourceModalState createState() => _CustomerSourceModalState();
}

class _CustomerSourceModalState extends State<CustomerSourceModal> {
//  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomMenuBottomSheet(
      title: AppLocalizations.text(LangKey.customerSource),
      widget: (widget.sources!.length > 0) ? CustomListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0.0),
                    children: (widget.sources ?? [])
                        .asMap()
                        .map((index, element) => MapEntry(
                        index,
                        CustomItemBottomSheet(
                          element?.sourceName ?? "",
                              () => selectedItem( index),
                          isBorder:
                          index < widget.sources!.length - 1,
                          isSelected: element.selected,
                        )))
                        .values
                        .toList(),
                  ) : CustomDataNotFound(),
      haveBnConfirm: false,
      
    );
  }


  selectedItem(int index) async {
    List<CustomerOptionSource> models = widget.sources!;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {
      Navigator.of(context).pop(models[index]);
    });
  }
}