import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/response/get_tag_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modal/create_new_tag_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_shimer.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';

class TagsModal extends StatefulWidget {
  List<TagData>? tagsData;
  TagsModal({Key? key, this.tagsData});

  @override
  _TagsModalState createState() => _TagsModalState();
}

class _TagsModalState extends State<TagsModal> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();
  List<TagData>? tagsData = [];
  List<TagData>? tagsDataDisplay = [];

  @override
  void initState() {
    super.initState();

    tagsData = widget.tagsData;
    tagsDataDisplay = tagsData;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // getData();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    super.dispose();
  }

  getData() async {
    keyboardDismissOnTap(context);

    LeadConnection.showLoading(context);
    var tags = await LeadConnection.getTag(context);
    Navigator.of(context).pop();
    if (tags != null) {
      tagsData!.add(tags.data!.elementAt(tags.data!.length-1));
      // tagsData = tags.data;
      tagsDataDisplay = tagsData;
    }

    setState(() {});
    // }
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
            AppLocalizations.text(LangKey.chooseCards)!,
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: () async {
                  var result = await showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CreateNewTagModal());
                      });
                  if (result != null && result) {
                    getData();
                  }
                },
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            )
          ],
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
          (tagsDataDisplay != null)
              ? (tagsDataDisplay!.length > 0)
                  ? Expanded(
                      child: CustomListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _controller,
                      separator: Divider(),
                      children: _listWidget(),
                    ))
                  : Expanded(child: CustomDataNotFound())
              : Expanded(child: Container()),
          CustomButton(
            text: AppLocalizations.text(LangKey.confirm),
            ontap: () {
              Navigator.of(context).pop(tagsData);
            },
          ),
          Container(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  List<Widget> _listWidget() {
    return (tagsDataDisplay != null && tagsDataDisplay!.length > 0)
        ? List.generate(
            tagsDataDisplay!.length,
            (index) => _buildItem(tagsDataDisplay![index], () {
                  selectedItem(tagsDataDisplay![index]);
                }))
        : [CustomDataNotFound()];
  }

  Widget _buildItem(TagData item, GestureTapCallback ontap) {
    return InkWell(
      onTap: ontap ,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40,
            child: Row(
              children: [
                Text(
                  item.name!,
                  style: TextStyle(
                      fontSize: 15.0,
                      color:
                          item.selected! ? AppColors.primaryColor : Colors.black,
                      fontWeight:
                          item.selected! ? FontWeight.bold : FontWeight.normal),
                )
              ],
            ),
          ),
          item.selected!
              ? Icon(
                  Icons.check_box,
                  color: AppColors.primaryColor,
                )
              : Icon(
                  Icons.check_box_outline_blank,
                  color: Color.fromARGB(255, 108, 102, 94),
                )
        ],
      ),
    );
  }

  Widget dataNotFound() {
    return CustomListView(
        shrinkWrap: true,
        padding:
            EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
        physics: NeverScrollableScrollPhysics(),
        separator: Divider(),
        children: List.generate(
          5,
          (index) => Container(
            margin: EdgeInsets.only(top: 15.0),
            child: CustomShimmer(
              child: CustomSkeleton(height: 50, radius: 5.0),
            ),
          ),
        ));
  }

  Widget _buildSearch() {
    return TextField(
      enabled: true,
      controller: _searchext,
      focusNode: _fonusNode,
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
        searchModel(event);
        print(event.toLowerCase());
        if (_searchext != null) {
          print(_searchext.text);
        }
      },
    );
  }

  searchModel(String value) {
    if (value.isEmpty) {
      tagsDataDisplay = tagsData;
      setState(() {});
    } else {
      try {
        List<TagData> models = tagsData!.where((model) {
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
        tagsDataDisplay = models;
        setState(() {});
      } catch (_) {
        setState(() {});
      }
    }
  }

  selectedItem(TagData item) async {
    item.selected = !item.selected!;

    setState(() {
      // widget.tagsData = models;
    });
  }
}
