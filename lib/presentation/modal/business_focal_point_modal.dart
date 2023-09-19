import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/request/list_customer_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/list_customer_lead_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';

import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class BusinessFocalPointModal extends StatefulWidget {
  ListCustomLeadItems? businessFocalPointSeleted = ListCustomLeadItems();
  List<ListCustomLeadItems>? businessFocalPointData = <ListCustomLeadItems>[];
  BusinessFocalPointModal(
      {Key? key, this.businessFocalPointData, this.businessFocalPointSeleted})
      : super(key: key);

  @override
  _BusinessFocalPointModalState createState() =>
      _BusinessFocalPointModalState();
}

class _BusinessFocalPointModalState extends State<BusinessFocalPointModal> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchext = TextEditingController();
  final FocusNode _fonusNode = FocusNode();

// ListCustomLeadData _model ;

//   ListCustomLeadModelRequest filterModel = ListCustomLeadModelRequest(
//       search: "",
//       page: 1,
//       statusAssign: "",
//       customerType: "business",
//       tagId: "",
//       customerSourceName: "",
//       isConvert: "",
//       staffFullName: "",
//       pipelineName: "",
//       journeyName: "",
//       createdAt: "",
//       allocationDate: "");

//   int currentPage = 1;
//   int nextPage = 2;

//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(_scrollListener);
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       getData(false);
//     });
//   }

//   _scrollListener() async {
//     if (_controller.offset >= _controller.position.maxScrollExtent &&
//         !_controller.position.outOfRange) {
//       if (this.currentPage < this.nextPage) {
//         filterModel.page = currentPage + 1;
//         getData(true);
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _controller.removeListener(() {});
//     super.dispose();
//   }

//   getData(bool loadMore, {int page}) async {
//     keyboardDismissOnTap(context);
//     FocusScope.of(context).unfocus();
//     ListCustomLeadModelReponse model = await LeadConnection.getList(
//         context,
//         ListCustomLeadModelRequest(
//             search: _searchext.text,
//             page: filterModel.page,
//             statusAssign: "",
//             customerType: "business",
//             tagId: "",
//             customerSourceName: "",
//             isConvert: "",
//             staffFullName: "",
//             pipelineName: "",
//             journeyName: "",
//             createdAt: "",
//             allocationDate: ""));
//     if (model != null) {
//       if (!loadMore) {
//         widget.businessFocalPointData = [];
//         widget.businessFocalPointData = model.data?.items;
//         // ignore: null_aware_before_operator
//         (model.data?.items?.length > 0) ??
//             _controller.animateTo(
//               _controller.position.minScrollExtent,
//               duration: Duration(seconds: 2),
//               curve: Curves.fastOutSlowIn,
//             );
//       } else {
//         widget.businessFocalPointData.addAll(model.data?.items);
//       }


//       for (int i = 0; i < widget.businessFocalPointData.length ; i++) {
//         if ((widget.businessFocalPointSeleted?.customerLeadCode ?? "") == widget.businessFocalPointData[i].customerLeadCode ) {
//           widget.businessFocalPointData[i].selected = true;
//         } else {
//           widget.businessFocalPointData[i].selected = false;
//         }

//       }

//       _model = ListCustomLeadData(
//         items: (widget.businessFocalPointData ?? <ListCustomLeadItems>[])
//             .map((e) => ListCustomLeadItems.fromJson(e.toJson()))
//             .toList());



//       currentPage = model.data?.pageInfo?.currentPage;
//       nextPage = model.data?.pageInfo?.nextPage;
//       setState(() {});
//     } else {
//       widget.businessFocalPointData = [];
//       setState(() {});
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF0067AC),
          title: Text(
            AppLocalizations.text(LangKey.businessFocalPoint)!,
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          // leadingWidth: 20.0,
        ),
        body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            // child: _buildBody()
            ));
  }

//   Widget _buildBody() {
//     return Container(
//       padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
//       child: Column(
//         children: [
//           _buildSearch(),
//           (widget.businessFocalPointData != null)
//               ? (widget.businessFocalPointData.length > 0) ? Expanded(
//                   child: CustomListView(
//                   shrinkWrap: true,
//                   padding: EdgeInsets.only(
//                       top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
//                   physics: AlwaysScrollableScrollPhysics(),
//                   controller: _controller,
//                   separator: Divider(),
//                   children: _listWidget(),
//                 )) : Container()
//               : CustomDataNotFound(),
//           (this.currentPage < this.nextPage) ? Container(
//             height: 20.0,
//             margin: EdgeInsets.only(bottom: 40),
//             child: Center(
//               child: Text("Scroll down to show more", style: TextStyle(
//                 color: AppColors.primaryColor,
//                 fontSize: 13.0,
//                 fontWeight: FontWeight.w500
//               ),),
//             ),
//           ) : Container()
//         ],
//       ),
//     );
//   }

//   List<Widget> _listWidget() {
//     return (_model?.items != null && _model.items.length > 0) ? List.generate(
//         _model.items.length,
//         (index) => _buildItemStaff(_model.items[index], () {
//               selectedStaff(index);
//             })) : [CustomDataNotFound()];
//   }

//   selectedStaff(int index) async {
//     List<ListCustomLeadItems> models = _model.items;
//     for (int i = 0; i < models.length; i++) {
//       models[i].selected = false;
//     }
//     models[index].selected = true;
//     setState(() {
//       Navigator.of(context).pop(models[index]);
//     });
//   }

//   Widget _buildItemStaff(ListCustomLeadItems item, GestureTapCallback ontap) {
//      return InkWell(
//       onTap: ontap,
//       child: Container(
//         height: 40,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               item.leadFullName,
//               style: TextStyle(
//                   fontSize: 15.0,
//                   color: item.selected ? AppColors.primaryColor: Color(0xFF040C21),
//                   fontWeight:
//                       item.selected ? FontWeight.w700 : FontWeight.w400),
//             ),

//             item.selected ? Icon(Icons.check, color: AppColors.primaryColor,size: 20,) : Container(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearch() {
//     return TextField(
//       enabled: true,
//       controller: _searchext,
//       focusNode: _fonusNode,
//       // focusNode: _focusNode,
//       keyboardType: TextInputType.text,
//       decoration: InputDecoration(
//         isCollapsed: true,
//         contentPadding: EdgeInsets.all(12.0),
//         border: OutlineInputBorder(
//           // borderSide:
//           //     BorderSide(width: 1, color: Color.fromARGB(255, 21, 230, 129)),
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(width: 1, color: Color(0xFFB8BFC9)),
//         ),
//         // hintText: AppLocalizations.text(LangKey.filterNameCodePhone),
//         hintText: AppLocalizations.text(LangKey.inputSearch),
//         hintStyle: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w400,
//           color: Color(0xFF8E8E8E)
//         ),
//         isDense: true,
//       ),
//       onChanged: (event) {
//         searchModel(widget.businessFocalPointData,event);
//         print(event.toLowerCase());
//         if (_searchext != null) {
//           print(_searchext.text);
          
//         }
//       },
//     );
//   }

//    searchModel(List<ListCustomLeadItems> model, String value) {
//     if (model == null || value.isEmpty) {
//       _model.items = widget.businessFocalPointData;
//       setState(() {
//       });
//     } else {
//       try {
//         List<ListCustomLeadItems> models = model.where((model) {
//           List<String> search = value.removeAccents().split(" ");
//           bool result = true;
//           for (String element in search) {
//             if (!((model.leadFullName ?? "").removeAccents().contains(element))) {
//               result = false;
//               break;
//             }
//           }
//           return result;
//         }).toList();
//         _model.items = models;
//         setState(() {
//       });
//       } catch (_) {
//         setState(() {
        
//       });
//       }
//     }
//   }
}

