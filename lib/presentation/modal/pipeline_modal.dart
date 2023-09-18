import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/response/get_pipeline_model_response.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_item_bottom_sheet.dart';

import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_menu_bottom_sheet.dart';

class PipelineModal extends StatefulWidget {
  List<PipelineData>? pipeLineData = <PipelineData>[];
 PipelineModal({ Key? key, this.pipeLineData }) : super(key: key);

  @override
  _PipelineModalState createState() => _PipelineModalState();
}

class _PipelineModalState extends State<PipelineModal> {
  // final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomMenuBottomSheet(
      title: AppLocalizations.text(LangKey.choosePipeline),
      widget: (widget.pipeLineData!.length > 0) ? CustomListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0.0),
                    children: (widget.pipeLineData ?? [])
                        .asMap()
                        .map((index, element) => MapEntry(
                        index,
                        CustomItemBottomSheet(
                          element.pipelineName ?? "",
                              () => selectedItem( index),
                          isBorder:
                          index < widget.pipeLineData!.length - 1,
                          isSelected: element.selected,
                        )))
                        .values
                        .toList(),
                  ) : CustomDataNotFound(),
      haveBnConfirm: false,
    );
  }

  selectedItem(int index) async {
    List<PipelineData> models = widget.pipeLineData!;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {
      Navigator.of(context).pop(models[index]);
    });
  }
}