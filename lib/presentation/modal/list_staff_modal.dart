import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class ListStaffModal extends StatefulWidget {
  const ListStaffModal({ Key? key }) : super(key: key);
  
  @override
  _ListStaffModalState createState() => _ListStaffModalState();
}

class _ListStaffModalState extends State<ListStaffModal> {
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
            AppLocalizations.text(LangKey.listBusiness)!,
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          // leadingWidth: 20.0,
        ),
        body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: _buildBody()),
            
      //       floatingActionButton: FloatingActionButton(
      //         backgroundColor: AppColors.primaryColor,
      //   onPressed: () async {
      //    var result = await showModalBottomSheet(
      //               context: context,
      //               useRootNavigator: true,
      //               isScrollControlled: true,
      //               backgroundColor: Colors.transparent,
      //               builder: (context) {
      //                 return GestureDetector(
      //                   onTap: () {
      //                     Navigator.of(context).pop();
      //                   },
      //                   child: CreateNewBusinessModal());
      //               });
      //           if (result != null) {
      //             }
      //   },
      //   child: const Icon(Icons.add,color: Colors.white, size: 50,),
      // ),
      );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
      child: Column(
        children: [
          _buildSearch(),
          (allocators != null) ?
          Expanded(
              child: CustomListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 19.0, bottom: 16.0),
            physics: AlwaysScrollableScrollPhysics(),
            controller: _controller,
            separatorPadding: 5.0,
            separator: Container(height: 8.0,),
            children: (_model != null) ? (_model!.data!.length > 0) ? _listWidget() : [CustomDataNotFound()] : [Container()],
            // children: _listWidget(),
          ))
          : Container(),
        ],
      ),
    );
  }

  List<Widget> _listWidget() {
    return List.generate(
        _model!.data!.length,
        (index) => _buildStaffItem(_model!.data![index], () {

        } ));
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

  Widget _buildStaffItem(AllocatorData item, Function ontap) {
    return InkWell(
      onTap: ontap as void Function()?,
      child: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        height: 80.0,
        decoration: BoxDecoration(
          boxShadow: [
                      BoxShadow(
                          blurRadius: 0.3,
                          spreadRadius: 0.3,
                          color: Color.fromRGBO(0, 0, 0, 0.25))
                    ],
            color: Colors.white,
            border: Border.all(
                width: 1.0, color: Color(0xFFC3C8D3), style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  _buildAvatar(item.fullName!),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      item.fullName!,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: item.selected! ? Colors.orange : Colors.black,
                          // color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.navigate_next, color: Color(0xFF0067AC), size: 30.0,)
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
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Color(0xFFB8BFC9)),
        ),
        // hintText: AppLocalizations.text(LangKey.filterNameCodePhone),
        hintText: AppLocalizations.text(LangKey.inputSearch),
        suffixIcon: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset(
            Assets.iconSearch,
          ),
        ),
         suffixIconConstraints:
                BoxConstraints(maxHeight: 40.0, maxWidth: 40.0),
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
        color: Color.fromARGB(255, 243, 245, 247),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10000.0),
        child: CustomAvatar(
          color: AppColors.primaryColor,
          name: name,
          textSize: 22.0,
        ),
      ),
    );
  }

  searchModel(List<AllocatorData>? model, String value) {
    if (model == null || value.isEmpty) {
      _model!.data = allocators;
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
        _model!.data = models;
        setState(() {});
      } catch (_) {
        setState(() {});
      }
    }
  }
}