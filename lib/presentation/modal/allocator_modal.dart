import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class AllocatorModal extends StatefulWidget {
  List<AllocatorData> allocatorData = <AllocatorData>[];
  AllocatorData allocatorSelected = AllocatorData();
  AllocatorModal({Key key, this.allocatorData, this.allocatorSelected})
      : super(key: key);

  @override
  _AllocatorModalState createState() => _AllocatorModalState();
}

class _AllocatorModalState extends State<AllocatorModal> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();
  GetAllocatorModelReponse _model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (int i = 0; i < widget.allocatorData.length; i++) {
        if ((widget.allocatorSelected?.staffId ?? "") ==
            widget.allocatorData[i].staffId) {
          widget.allocatorData[i].selected = true;
        } else {
          widget.allocatorData[i].selected = false;
        }
      }

      _model = GetAllocatorModelReponse(
          data: (widget.allocatorData ?? <AllocatorData>[])
              .map((e) => AllocatorData.fromJson(e.toJson()))
              .toList());

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 50),
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
              Container(width: 30,),
              Text(
                AppLocalizations.text(LangKey.chooseAllottedPerson),
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.clear),
                ),
              ),
            ],
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
                        top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
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

  List<Widget> _listWidget() {
    return (_model.data != null)
        ? List.generate(
            _model.data.length,
            (index) => _buildItem(
                    _model.data[index].fullName, _model.data[index].selected,
                    () {
                  selectedItem(index);
                }))
        : [CustomDataNotFound()];
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
                  fontSize: 17.0,
                  color: selected ? Colors.orange : Colors.black,
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
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
        print(event.toLowerCase());
        if (_searchext != null) {
          print(_searchext.text);

          searchModel(widget.allocatorData, event);
        }
      },
    );
  }

  searchModel(List<AllocatorData> model, String value) {
    if (model == null || value.isEmpty) {
      _model.data = widget.allocatorData;
      setState(() {});
    } else {
      try {
        List<AllocatorData> models = model.where((model) {
          List<String> search = value.removeAccents().split(" ");
          bool result = true;
          for (String element in search) {
            if (!((model.fullName ?? "").removeAccents().contains(element))) {
              result = false;
              break;
            }
          }
          return result;
        }).toList();
        _model.data = models;
        setState(() {});
      } catch (_) {
        setState(() {});
      }
    }
  }

  selectedItem(int index) async {
    List<AllocatorData> models = _model.data;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {
      Navigator.of(context).pop(models[index]);
    });
  }
}
