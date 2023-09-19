// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lead_plugin_epoint/common/lang_key.dart';
// import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
// import 'package:lead_plugin_epoint/model/filter_screen_model.dart';
// import 'package:lead_plugin_epoint/model/work_schedule_date.dart';
// import 'package:lead_plugin_epoint/utils/global.dart';
// import 'package:lead_plugin_epoint/widget/custom_date_picker.dart';
// import 'package:lead_plugin_epoint/widget/custom_menu_bottom_sheet.dart';

// class FilterWorkScheduleDate extends StatefulWidget {
//   FilterScreenModel filterScreenModel = FilterScreenModel();
//   List<WorkScheduleModel> workScheduleDateOptions = <WorkScheduleModel>[];
//    String id_work_schedule_date;
//   FilterWorkScheduleDate(
//       {Key key, this.filterScreenModel, this.workScheduleDateOptions,this.id_work_schedule_date})
//       : super(key: key);

//   @override
//   FilterWorkScheduleState createState() => FilterWorkScheduleState();
// }

// class FilterWorkScheduleState extends State<FilterWorkScheduleDate> {

 
//   DateTime _fromDate;
//   DateTime _toDate;
//   DateTime _now = DateTime.now();
//   final TextEditingController _fromDateText = TextEditingController();
//   final TextEditingController _toDateText = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     if (widget.filterScreenModel.fromDate_work_schedule_date != null) {
//       _fromDateText.text = DateFormat("dd/MM/yyyy")
//           .format(widget.filterScreenModel.fromDate_work_schedule_date);
//       _fromDate = widget.filterScreenModel.fromDate_work_schedule_date;
//     }

//     if (widget.filterScreenModel.toDate_work_schedule_date != null) {
//       _toDateText.text = DateFormat("dd/MM/yyyy")
//           .format(widget.filterScreenModel.toDate_work_schedule_date);
//       _toDate = widget.filterScreenModel.toDate_work_schedule_date;
//     }

//     if (widget.filterScreenModel.id_work_schedule_date != "") {
//       for (int i = 0; i < widget.workScheduleDateOptions.length; i++) {
//         if (widget.workScheduleDateOptions[i].workscheduleDateID ==
//             int.parse(widget.filterScreenModel.id_work_schedule_date)) {
//           widget.workScheduleDateOptions[i].selected = true;
//           widget.id_work_schedule_date =  "${widget.workScheduleDateOptions[i].workscheduleDateID}";
//         } else {
//           widget.workScheduleDateOptions[i].selected = false;
//         }
//       }
//     }

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return (widget.workScheduleDateOptions != null)
//         ? Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
//                 child: Wrap(
//                   children: List.generate(
//                       widget.workScheduleDateOptions.length,
//                       (index) => _optionItem(
//                               widget.workScheduleDateOptions[index].workscheduleDateName,
//                               widget.workScheduleDateOptions[index].selected, () {
//                             selectedSource(index);
//                           })),
//                   spacing: 20,
//                   runSpacing: 10,
//                 ),
//               ),
//               (widget.id_work_schedule_date == "6")
//                   ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // khung thời gian tự chọn
//                         Text(
//                           AppLocalizations.text(LangKey.byWorkSchedule),
//                           style: TextStyle(
//                               fontSize: 15.0,
//                               color: const Color(0xFF8E8E8E),
//                               fontWeight: FontWeight.normal),
//                         ),
//                         Container(height: 10,),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                                 margin: const EdgeInsets.only(bottom: 10.0),
//                                 width:
//                                     (MediaQuery.of(context).size.width - 60) /
//                                             2 -
//                                         8,
//                                 child: _buildDatePicker(
//                                     AppLocalizations.text(LangKey.fromDate),
//                                      widget.id_work_schedule_date != "" ? _fromDateText : "", () {
//                                   _showFromDatePickerCreateDate();
//                                 })),
//                             Container(
//                                 margin: EdgeInsets.only(left: 15, right: 5),
//                                 child: Text(
//                                   "-",
//                                   style: TextStyle(color: Color(0xFF8E8E8E)),
//                                 )),
//                             Container(
//                                 margin: const EdgeInsets.only(
//                                     bottom: 10.0, left: 10.0),
//                                 width:
//                                     (MediaQuery.of(context).size.width - 60) /
//                                             2 -
//                                         4,
//                                 child: _buildDatePicker(
//                                     AppLocalizations.text(LangKey.toDate),
//                                     widget.id_work_schedule_date != "" ?  _toDateText : "", () {
//                                   _showToDatePickerCreateDate();
//                                 }))
//                           ],
//                         ),
//                       ],
//                     )
//                   : Container(),
//             ],
//           )
//         : Container();
//   }

//   _showFromDatePickerCreateDate() {
//     DateTime selectedDate = widget.filterScreenModel.fromDate_work_schedule_date ??
//         _fromDate ??
//         _toDate ??
//         _now;

//     showModalBottomSheet(
//         context: context,
//         useRootNavigator: true,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         isDismissible: false,
//         builder: (context) {
//           return Container(
//             height: MediaQuery.of(context).size.height * 0.7,
//             child: CustomMenuBottomSheet(
//               title: AppLocalizations.text(LangKey.fromDate),
//               widget: CustomDatePicker(
//                 initTime: selectedDate,
//                 maximumTime: _toDate,
//                 dateOrder: DatePickerDateOrder.dmy,
//                 onChange: (DateTime date) {
//                   selectedDate = date;
//                 },
//               ),
//               onTapConfirm: () {

//                 if (_toDate == null) {
//                   Global.validateWorkScheduleDate = false;
//                 } else {
//                   Global.validateWorkScheduleDate = true;
//                 }
                
//                 _fromDate = selectedDate;
//                 widget.filterScreenModel.fromDate_work_schedule_date = selectedDate;

//                 _fromDateText.text =
//                     DateFormat("dd/MM/yyyy").format(selectedDate).toString();
//                 widget.filterScreenModel.filterModel.workScheduleDate =
//                     "${DateFormat("dd/MM/yyyy").format(_fromDate)} - ${DateFormat("dd/MM/yyyy").format(_toDate ?? _now)}";
//                 print(widget.filterScreenModel.filterModel.workScheduleDate);
//                 Navigator.of(context).pop();
//               },
//               haveBnConfirm: true,
//             ),
//           );
//         });
//   }

// _showToDatePickerCreateDate() {
//     DateTime selectedDate = _toDate ?? _now;
//     DateTime maximumTime = _now;
//     if (_toDate?.year == _now.year &&
//         _toDate?.month == _now.month &&
//         _toDate?.day > _now.day) maximumTime = _toDate;
//     showModalBottomSheet(
//         context: context,
//         useRootNavigator: true,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         isDismissible: false,
//         builder: (context) {
//           return Container(
//             height: MediaQuery.of(context).size.height * 0.7,
//             child: CustomMenuBottomSheet(
//               title: AppLocalizations.text(LangKey.toDate),
//               widget: CustomDatePicker(
//                 initTime: selectedDate,
//                 maximumTime: maximumTime,
//                 minimumTime: _fromDate,
//                 dateOrder: DatePickerDateOrder.dmy,
//                 onChange: (DateTime date) {
//                   selectedDate = date;
//                 },
//               ),
//               onTapConfirm: () {
//                 if (_fromDate == null) {
//                   Global.validateWorkScheduleDate = false;
//                 } else {
//                   Global.validateWorkScheduleDate = true;
//                 }
//                 _toDate = selectedDate;
//                 widget.filterScreenModel.toDate_work_schedule_date = selectedDate;
//                 _toDateText.text =
//                     DateFormat("dd/MM/yyyy").format(selectedDate).toString();
//                 widget.filterScreenModel.filterModel.workScheduleDate = "${DateFormat("dd/MM/yyyy").format(_fromDate ?? _toDate ?? _now)} - ${DateFormat("dd/MM/yyyy").format(_toDate)}";
//                 print(widget.filterScreenModel.filterModel.workScheduleDate);
//                 Navigator.of(context).pop();
//               },
//               haveBnConfirm: true,
//             ),
//           );
//         });
//   }

//   Widget _buildDatePicker(
//       String hintText, TextEditingController fillText, GestureTapCallback ontap) {
//     return InkWell(
//       onTap: ontap,
//       child: TextField(
//         enabled: false,
//         controller: fillText,
//         keyboardType: TextInputType.text,
//         decoration: InputDecoration(
//           isCollapsed: true,
//           contentPadding: EdgeInsets.all(12.0),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           hintText: hintText,
//           hintStyle: TextStyle(
//               fontSize: 14.0,
//               color: Color(0xFF8E8E8E),
//               fontWeight: FontWeight.normal),
//           isDense: true,
//         ),
//         // },
//       ),
//     );
//   }

//   Widget _optionItem(String name, bool selected, GestureTapCallback ontap) {
//     return InkWell(
//       onTap: ontap,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           selected
//               ? Container(
//                   padding: EdgeInsets.only(left: 8.0, right: 8.0),
//                   height: 40,
//                   // width: 100,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5.0),
//                       border: Border.all(
//                           width: 1.0,
//                           color: Colors.blue,
//                           style: BorderStyle.solid)),
//                   child: Center(
//                     child: Text(
//                       name,
//                       style: TextStyle(
//                           color: Color(0xFF0067AC),
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 )
//               : Container(
//                   padding: EdgeInsets.only(left: 8.0, right: 8.0),
//                   height: 40,
//                   // width: 100,
//                   decoration: BoxDecoration(
//                       color: Color(0xFFEAEAEA),
//                       borderRadius: BorderRadius.circular(5.0)),
//                   child: Center(
//                     child: Text(
//                       name,
//                       style: TextStyle(color: Color(0xFF8E8E8E)),
//                     ),
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }

//   selectedSource(int index) async {
//     if (index != 6) {
//       Global.validateWorkScheduleDate = true;
//       _fromDateText.text = "";
//       _toDateText.text = "";

//       widget.filterScreenModel.fromDate_work_schedule_date = null;
//       widget.filterScreenModel.toDate_work_schedule_date = null;
//       _fromDate = null;
//       _toDate = null;
//     } else {
//       Global.validateWorkScheduleDate = false;
//     }

//     List<WorkScheduleModel> models = widget.workScheduleDateOptions;
//     for (int i = 0; i < models.length; i++) {
//       models[i].selected = false;
//     }
//     models[index].selected = true;
//     widget.id_work_schedule_date = "${models[index].workscheduleDateID}";
//     widget.filterScreenModel.id_work_schedule_date = "${index}";

//     switch (index) {
//       case 0:
//         widget.filterScreenModel.filterModel.workScheduleDate =
//             "${DateFormat("dd/MM/yyyy").format(_now)} - ${DateFormat("dd/MM/yyyy").format(_now)}";
//         print(widget.filterScreenModel.filterModel.workScheduleDate);
//         break;
//       case 1:
//         widget.filterScreenModel.filterModel.workScheduleDate =
//             "${DateFormat("dd/MM/yyyy").format(_now.subtract(Duration(days: 1)))} - ${DateFormat("dd/MM/yyyy").format(_now.subtract(Duration(days: 1)))}";
//         print(widget.filterScreenModel.filterModel.workScheduleDate);
//         break;
//       case 2:
//         widget.filterScreenModel.filterModel.workScheduleDate =
//             "${DateFormat("dd/MM/yyyy").format(_now.subtract(Duration(days: 7)))} - ${DateFormat("dd/MM/yyyy").format(_now)}";
//         print(widget.filterScreenModel.filterModel.workScheduleDate);
//         break;
//       case 3:
//         widget.filterScreenModel.filterModel.workScheduleDate =
//             "${DateFormat("dd/MM/yyyy").format(_now.subtract(Duration(days: 31)))} - ${DateFormat("dd/MM/yyyy").format(_now.subtract(Duration(days: 1)))}";
//         print(widget.filterScreenModel.filterModel.workScheduleDate);
//         break;
//       case 4:
//         widget.filterScreenModel.filterModel.workScheduleDate =
//             "${DateFormat("dd/MM/yyyy").format(DateTime.parse(DateTime(_now.year, _now.month, 1).toString()))} - ${DateFormat("dd/MM/yyyy").format(DateTime.parse(DateTime(_now.year, _now.month + 1, 0).toString()))}";
//         print(widget.filterScreenModel.filterModel.workScheduleDate);
//         break;
//       case 5:
//         var lastmonth = _now.month - 1;
//         widget.filterScreenModel.filterModel.workScheduleDate =
//             "${DateFormat("dd/MM/yyyy").format(DateTime.parse(DateTime(_now.year, _now.month - 1, 1).toString()))} - ${DateFormat("dd/MM/yyyy").format(DateTime.parse(DateTime(_now.year, lastmonth + 1, 0).toString()))}";
//         print(widget.filterScreenModel.filterModel.workScheduleDate);
//         break;
//       case 6:
//         widget.filterScreenModel.filterModel.workScheduleDate = "";
//         print(widget.filterScreenModel.filterModel.workScheduleDate);
//         break;
//       default:
//     }

//     setState(() {});
//   }
// }
