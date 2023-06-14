import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/model/convert_status.dart';

class FilterByConvertStatus extends StatefulWidget {
  List<ConvertStatusModel>? convertStatusOptions = <ConvertStatusModel>[];
 FilterByConvertStatus({ Key? key ,this.convertStatusOptions}) : super(key: key);

  @override
  _FilterByConvertStatusState createState() => _FilterByConvertStatusState();
}

class _FilterByConvertStatusState extends State<FilterByConvertStatus> {
  @override
  Widget build(BuildContext context) {
    return (widget.convertStatusOptions != null)
        ? Container(
            margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Wrap(
              children: List.generate(
                  widget.convertStatusOptions!.length,
                  (index) => _optionItem(
                          widget.convertStatusOptions![index].statusName,
                          widget.convertStatusOptions![index].selected!, () {
                        selectedSource(index);
                      })),
              spacing: 10,
              runSpacing: 10,
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

  selectedSource(int index) async {
    List<ConvertStatusModel> models = widget.convertStatusOptions!;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {});
  }
}