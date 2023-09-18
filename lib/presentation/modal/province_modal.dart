import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/response/get_province_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';

import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class ProvinceModal extends StatefulWidget {
  List<ProvinceData>? provinces = <ProvinceData>[];
  ProvinceData? provinceSeleted = ProvinceData();
  ProvinceModal({Key? key, this.provinces, this.provinceSeleted})
      : super(key: key);

  @override
  _ProvinceModalState createState() => _ProvinceModalState();
}

class _ProvinceModalState extends State<ProvinceModal> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();
  GetProvinceModel? _model;
  List<ProvinceData>? provinces = <ProvinceData>[];
  ProvinceData? provinceSeleted = ProvinceData();

  @override
  void initState() {
    super.initState();
    provinces = widget.provinces;
    provinceSeleted = widget.provinceSeleted;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (int i = 0; i < provinces!.length; i++) {
        if ((provinceSeleted?.provinceid ?? "") ==
            provinces![i].provinceid) {
          provinces![i].selected = true;
        } else {
          provinces![i].selected = false;
        }
      }

      _model = GetProvinceModel(
          province: (provinces ?? <ProvinceData>[])
              .map((e) => ProvinceData.fromJson(e.toJson()))
              .toList());

      setState(() {});
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
          Container(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.clear,
                      size: 20.0,
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.text(LangKey.provinceCity)!,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  width: 30,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSearch(),
          ),
          (_model != null)
              ? Expanded(
                  child: CustomListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        top: 16.0, bottom: 16.0, left: 16.0, right: 8.0),
                    physics: ClampingScrollPhysics(),
                    controller: _controller,
                    separator: Divider(),
                    children: _listWidget(),
                  ),
                )
              : Container(),
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
        searchModel(provinces, event);
        print(event.toLowerCase());
        if (_searchext != null) {
          print(_searchext.text);
        }
      },
    );
  }

  searchModel(List<ProvinceData>? model, String value) {
    if (model == null || value.isEmpty) {
      _model!.province = provinces;
      setState(() {});
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
        _model!.province = models;
        setState(() {});
      } catch (_) {
        setState(() {});
      }
    }
  }

  List<Widget> _listWidget() {
    return (_model!.province != null)
        ? (_model!.province!.length > 0) ? List.generate(
            _model!.province!.length,
            (index) => _buildItem(
                    _model!.province![index].name!, _model!.province![index].selected!, () {
                  selectedItem(index);
                }))
        : [CustomDataNotFound()]: Container() as List<Widget>;
  }

  Widget _buildItem(String title, bool selected, Function ontap) {
    return InkWell(
      onTap: ontap as void Function()?,
      child: Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 15.0,
                  color: selected ?AppColors.primaryColor : Color(0xFF040C21),
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w400),
            ),

            selected ? Icon(Icons.check, color: AppColors.primaryColor,size: 20,) : Container(),
          ],
        ),
      ),
    );
  }

  selectedItem(int index) async {
    List<ProvinceData> models = _model!.province!;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {
      Navigator.of(context).pop(models[index]);
    });
  }
}
