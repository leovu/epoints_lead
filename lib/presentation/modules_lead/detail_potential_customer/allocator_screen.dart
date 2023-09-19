import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';

import 'package:lead_plugin_epoint/widget/custom_avatar.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class AllocatorScreen extends StatefulWidget {
  const AllocatorScreen({Key? key}) : super(key: key);

  @override
  _AllocatorScreenState createState() => _AllocatorScreenState();
}

class _AllocatorScreenState extends State<AllocatorScreen> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();
  GetAllocatorModelReponse? _model;
  List<AllocatorData>? allocators = <AllocatorData>[];
  late GetAllocatorModelReponse dataAllocator;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      LeadConnection.showLoading(context);
      var data = await LeadConnection.getAllocator(context);
      if (data != null) {
        dataAllocator = data;
        allocators = data.data;

         _model = GetAllocatorModelReponse(
        data: (allocators ?? <AllocatorData>[])
            .map((e) => AllocatorData.fromJson(e.toJson()))
            .toList());
      }

      Navigator.of(context).pop();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF0067AC),
          title: Text(
            AppLocalizations.text(LangKey.staff)!,
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          // leadingWidth: 20.0,
        ),
        body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: _buildBody()));
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
      child: Column(
        children: [
          _buildSearch(),
          (allocators != null)
              ? Expanded(
                  child: CustomListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _controller,
                  separator: Divider(),
                  children: (_model != null) ? (_model!.data!.length > 0) ? _listWidget() : [CustomDataNotFound()] : [Container()],
                ))
              : Container(),
          Container(
            height: 20.0,
          )
        ],
      ),
    );
  }

  List<Widget> _listWidget() {
    return List.generate(
        _model!.data!.length,
        (index) => _buildItemStaff(_model!.data![index], () {
              selectedStaff(index);
            }));
  }

  selectedStaff(int index) async {
    List<AllocatorData> models = dataAllocator.data!;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    setState(() {
      Navigator.of(context).pop(models[index].staffId);
    });
  }

  Widget _buildItemStaff(AllocatorData item, GestureTapCallback ontap) {
    return InkWell(
      onTap: ontap ,
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            _buildAvatar(item.fullName!),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  item.fullName!,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: item.selected! ? Colors.orange : Colors.black,
                      fontWeight: FontWeight.normal),
                  maxLines: 1,
                ),
              ),
            ),
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

          searchModel(allocators,event);
        }
      },
    );
  }

  Widget _buildAvatar(String name) {
    return Container(
      width: 50.0,
      height: 50.0,
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // color: Color.fromARGB(255, 243, 245, 247),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10000.0),
        child: CustomAvatar(
          color: Color.fromARGB(255, 117, 176, 215),
          name: name,
          textSize: 22.0,
        ),
      ),
    );
  }

  searchModel(List<AllocatorData>? model, String value) {
    if (model == null || value.isEmpty) {
      _model!.data = allocators;
      setState(() {
      });
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
        _model!.data = models;
        setState(() {
      });
      } catch (_) {
        setState(() {
        
      });
      }
    }
  }
}

extension NumberParsing on String {
  double? tryParseDouble({bool isRound = false}) {
    if (this == null || this == "null") {
      return 0.0;
    }
    String param = this.toString().replaceAll(",", "");
    double? val = double.tryParse(param);
    return val == null
        ? 0.0
        : (isRound ? double.tryParse(val.toStringAsFixed(2)) : val);
  }

  String removeAccents() {
    List<String> chars = this.toLowerCase().split("");
    String a = "áàảạãăắằẳặẵâấầẩẫậ";
    String d = "đ";
    String e = "éèẻẽẹêếềểễệ";
    String i = "íìỉĩị";
    String o = "óòỏõọôốồổỗộơớờởỡợ";
    String u = "úùủũụưứừửữự";
    String y = "ýỳỷỹỵ";
    String result = "";
    chars.forEach((element) {
      if (a.contains(element))
        element = "a";
      else if (d.contains(element)) {
        element = "d";
      } else if (e.contains(element)) {
        element = "e";
      } else if (i.contains(element)) {
        element = "i";
      } else if (o.contains(element)) {
        element = "o";
      } else if (u.contains(element)) {
        element = "u";
      } else if (y.contains(element)) {
        element = "y";
      }
      result += element;
    });
    return result;
  }
}
