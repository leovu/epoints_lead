import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/response/get_province_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';

import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class ProvinceModal extends StatefulWidget {
  List<ProvinceData> provinces = <ProvinceData>[];
  ProvinceData provinceSeleted = ProvinceData();
  ProvinceModal({Key key, this.provinces, this.provinceSeleted}) : super(key: key);

  @override
  _ProvinceModalState createState() => _ProvinceModalState();
}

class _ProvinceModalState extends State<ProvinceModal> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();
  GetProvinceModelReponse _model;


   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
         for (int i = 0; i < widget.provinces.length ; i++) {
        if ((widget.provinceSeleted?.provinceid ?? "") == widget.provinces[i].provinceid ) {
          widget.provinces[i].selected = true;
        } else {
          widget.provinces[i].selected = false;
        }
      }


      _model = GetProvinceModelReponse(
        data: (widget.provinces ?? <ProvinceData>[])
            .map((e) => ProvinceData.fromJson(e.toJson()))
            .toList());

            setState(() {
      
    });
    });
    
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 50, top: 10),
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
              Text(AppLocalizations.text(LangKey.provinceCity),style: TextStyle(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSearch(),
          ),
          ( _model != null ) ? Expanded(
            child: CustomListView(
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
                  physics: ClampingScrollPhysics(),
                  controller: _controller,
                  separator: Divider(),
                  children: _listWidget(),
                ),
          ) : Container(),
        ],
      ),
    );
  }

    Widget _buildSearch() {
    return TextField(
      enabled: true,
      controller: _searchext,
      focusNode: _fonusNode,
      // focusNode: _focusNode,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.all(12.0),
        border: OutlineInputBorder(
          // borderSide:
          //     BorderSide(width: 1, color: Color.fromARGB(255, 21, 230, 129)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Color(0xFFB8BFC9)),
        ),
        // hintText: AppLocalizations.text(LangKey.filterNameCodePhone),
        hintText: AppLocalizations.text(LangKey.inputSearch),
        isDense: true,
      ),
      onChanged: (event) {
        searchModel(widget.provinces,event);
        print(event.toLowerCase());
        if (_searchext != null) {
          print(_searchext.text);
          
        }
      },
    );
  }

 searchModel(List<ProvinceData> model, String value) {
    if (model == null || value.isEmpty) {
      _model.data = widget.provinces;
      setState(() {
      });
    } else {
      try {
        List<ProvinceData> models = model.where((model) {
          List<String> search = value.removeAccents().split(" ");
          bool result = true;
          for (String element in search) {
            if (!((model.name ?? "").removeAccents().contains(element))) {
              result = false;
              break;
            }
          }
          return result;
        }).toList();
        _model.data = models;
        setState(() {
      });
      } catch (_) {
        setState(() {
        
      });
      }
    }
  }

  List<Widget> _listWidget() {
    return List.generate(
        _model.data.length,
        (index) => _buildItem(
                _model.data[index].name, _model.data[index].selected,
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
    List<ProvinceData> models = _model.data;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {
      Navigator.of(context).pop(models[index]);
    });
  }
}
