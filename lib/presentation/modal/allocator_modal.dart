import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class AllocatorModal extends StatefulWidget {
  List<AllocatorData> allocatorData = <AllocatorData>[];
   AllocatorModal({ Key key ,this.allocatorData}) : super(key: key);

  @override
  _AllocatorModalState createState() => _AllocatorModalState();
}

class _AllocatorModalState extends State<AllocatorModal> {
 final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0,bottom: 50),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Text(AppLocalizations.text(LangKey.chooseAllottedPerson),style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.clear),
                ),
              ),
            
            ],
          ),
          Expanded(
            child: CustomListView(
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
                  physics: ClampingScrollPhysics(),
                  controller: _controller,
                  separator: Divider(),
                  children: _listWidget(),
                ),
          ),
        ],
      ),
    );
  }

  List<Widget> _listWidget() {
    return List.generate(
        widget.allocatorData.length,
        (index) => _buildItem(
                widget.allocatorData[index].fullName, widget.allocatorData[index].selected,
                () {
              selectedItem(index);
            }));
  }

  Widget _buildItem(String title, bool selected, Function ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 40,
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18.0,
                  color: selected ? Colors.orange : Colors.black,
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }

  selectedItem(int index) async {
    List<AllocatorData> models = widget.allocatorData;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {
      Navigator.of(context).pop(models[index]);
    });
  }
}