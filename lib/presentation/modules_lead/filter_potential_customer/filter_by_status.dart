import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/model/response/get_tag_model_response.dart';
import 'package:lead_plugin_epoint/model/status_assign_model.dart';

class FilterBySatus extends StatefulWidget {
 List<StatusAssignModel>? statusOptions = <StatusAssignModel>[];
  FilterBySatus({Key? key, this.statusOptions}) : super(key: key);

  @override
  _FilterBySatusState createState() => _FilterBySatusState();
}

class _FilterBySatusState extends State<FilterBySatus> {
  @override
  Widget build(BuildContext context) {
    return (widget.statusOptions != null)
        ? Container(
            margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Wrap(
              children: List.generate(
                  widget.statusOptions!.length,
                  (index) => _optionItem(widget.statusOptions![index].statusName,
                          widget.statusOptions![index].selected!, () {
                        selectedItem(index);
                      })),
              spacing: 20,
              runSpacing: 20,
            ),
          )
        : Container();
  }

  Widget _optionItem(String? name, bool selected, GestureTapCallback ontap) {
    return InkWell(
      onTap: ontap ,
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
    List<StatusAssignModel> models = widget.statusOptions!;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {});
  }
}