import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/response/get_type_work_response_model.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_item_bottom_sheet.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_menu_bottom_sheet.dart';

class TypeOfWorkModal extends StatefulWidget {
  List<GetTypeWorkData> typeOfWorkData;
  TypeOfWorkModal({ Key key, this.typeOfWorkData }) : super(key: key);

  @override
  _TypeOfWorkModalState createState() => _TypeOfWorkModalState();
}

class _TypeOfWorkModalState extends State<TypeOfWorkModal> {

  @override
  Widget build(BuildContext context) {
    return CustomMenuBottomSheet(
      title: AppLocalizations.text(LangKey.chooseTypeOfWork),
      widget: (widget.typeOfWorkData.length > 0) ? CustomListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0.0),
                    children: (widget.typeOfWorkData ?? [])
                        .asMap()
                        .map((index, element) => MapEntry(
                        index,
                        CustomItemBottomSheet(
                          element?.manageTypeWorkName ?? "",
                              () => selectedItem( index),
                          isBorder:
                          index < widget.typeOfWorkData.length - 1,
                          isSelected: element.selected,
                        )))
                        .values
                        .toList(),
                  ) : CustomDataNotFound(),
      haveBnConfirm: false,
    );
  }


  selectedItem(int index) async {
    List<GetTypeWorkData> models = widget.typeOfWorkData;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {
      Navigator.of(context).pop(models[index]);
    });
  }
}