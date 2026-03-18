

import 'package:flutter/widgets.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_group_model_response.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_item_bottom_sheet.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_menu_bottom_sheet.dart';

class GroupCustomerModal extends StatefulWidget {
 final List<CustomerGroupData>? datas;
 GroupCustomerModal({ Key? key , this.datas}) : super(key: key);

  @override
  _GroupCustomerModalState createState() => _GroupCustomerModalState();
}

class _GroupCustomerModalState extends State<GroupCustomerModal> {
  // final ScrollController _controller = ScrollController();

  CustomerGroupData? dataSelected;

  @override
  Widget build(BuildContext context) {
    return CustomMenuBottomSheet(
      title: "Nhóm khách hàng",
      widget: (widget.datas!.length > 0) ? CustomListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0.0),
                    children: (widget.datas ?? [])
                        .asMap()
                        .map((index, element) => MapEntry(
                        index,
                        CustomItemBottomSheet(
                          element.groupName ?? "",
                              () => selectedItem( index),
                          isBorder:
                          index < widget.datas!.length - 1,
                          isSelected: element.selected,
                        )))
                        .values
                        .toList(),
                  ) : CustomDataNotFound(),
      haveBnConfirm: false,
      
    );
  }

  selectedItem(int index) async {
    List<CustomerGroupData> models = widget.datas!;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {
      Navigator.of(context).pop(models[index]);
    });
  }
}