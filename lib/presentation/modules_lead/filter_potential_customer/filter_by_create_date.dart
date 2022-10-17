import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/create_date.dart';
import 'package:lead_plugin_epoint/model/filter_screen_model.dart';
import 'package:lead_plugin_epoint/utils/navigator.dart';
import 'package:lead_plugin_epoint/widget/custom_date_picker.dart';
import 'package:lead_plugin_epoint/widget/custom_meni_bottom_sheet.dart';

class FilterByCreateDate extends StatefulWidget {

  FilterScreenModel filterScreenModel = FilterScreenModel();
  
  // ListCustomLeadModelRequest filterModel = ListCustomLeadModelRequest();
  List<CreateDateModel> createDateOptions = <CreateDateModel>[];
  FilterByCreateDate({Key key, this.createDateOptions, this.filterScreenModel})
      : super(key: key);

  @override
  _FilterByCreateDateState createState() => _FilterByCreateDateState();
}

class _FilterByCreateDateState extends State<FilterByCreateDate> {
  CreateDateModel creatDateSeleted = CreateDateModel();

  DateTime _fromDate;
  DateTime _toDate;
  DateTime _now = DateTime.now();
  final TextEditingController _fromDateText = TextEditingController();
  final TextEditingController _toDateText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _toDate = _now;

    if (widget.filterScreenModel.fromDate_created_at != null) {
      _fromDateText.text = DateFormat("dd/MM/yyyy").format(widget.filterScreenModel.fromDate_created_at);
      _fromDate = widget.filterScreenModel.fromDate_created_at;
    }

    if (widget.filterScreenModel.toDate_created_at != null) {
      _toDateText.text = DateFormat("dd/MM/yyyy").format(widget.filterScreenModel.toDate_created_at);
      _toDate = widget.filterScreenModel.toDate_created_at;
    }

    if (widget.filterScreenModel.id_created_at != "") {
      for (int i = 0; i < widget.createDateOptions.length ; i++) {
          if (widget.createDateOptions[i].createDateID == int.parse(widget.filterScreenModel.id_created_at) ) {
            widget.createDateOptions[i].selected = true;
            creatDateSeleted =  widget.createDateOptions[i];
          } else {
            widget.createDateOptions[i].selected = false;
          }
      }
    }

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.createDateOptions != null)
        ? Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Wrap(
                  children: List.generate(
                      widget.createDateOptions.length,
                      (index) => _optionItem(
                              widget.createDateOptions[index].createDateName,
                              widget.createDateOptions[index].selected, () {
                            selectedSource(index);
                          })),
                  spacing: 20,
                  runSpacing: 20,
                ),
              ),
              (creatDateSeleted?.createDateID == 6)
                  ? Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // khung thời gian tự chọn
                        Text(
                          AppLocalizations.text(LangKey.customerTimeFrame),
                          style: TextStyle(
                              fontSize: 15.0,
                              color: const Color(0xFF8E8E8E),
                              fontWeight: FontWeight.normal),
                        ),
                        Container(height: 10,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                width:
                                    (MediaQuery.of(context).size.width - 60) / 2 -
                                        8,
                                child: _buildDatePicker(
                                    AppLocalizations.text(LangKey.fromDate),
                                    _fromDateText, () {
                                  _showFromDatePickerCreateDate();
                                })),
                            Container(
                                margin: EdgeInsets.only(left: 15, right: 5),
                                child: Text(
                                  "-",
                                  style: TextStyle(color: Color(0xFF8E8E8E)),
                                )),
                            Container(
                                margin:
                                    const EdgeInsets.only(bottom: 10.0, left: 10.0),
                                width:
                                    (MediaQuery.of(context).size.width - 60) / 2 -
                                        4,
                                child: _buildDatePicker(
                                    AppLocalizations.text(LangKey.toDate),
                                    _toDateText, () {
                                  _showToDatePickerCreateDate();
                                }))
                          ],
                        ),
                    ],
                  )
                  : Container(),
            ],
          )
        : Container();
  }

  _showFromDatePickerCreateDate() {
    DateTime selectedDate = widget.filterScreenModel.fromDate_created_at ?? _fromDate ?? _toDate ?? _now;

    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: CustomMenuBottomSheet(
              title: AppLocalizations.text(LangKey.fromDate),
              widget: CustomDatePicker(
                initTime: selectedDate,
                maximumTime: _toDate,
                dateOrder: DatePickerDateOrder.dmy,
                onChange: (DateTime date) {
                  selectedDate = date;
                },
              ),
              onTapConfirm: () {
                _fromDate = selectedDate;
                widget.filterScreenModel.fromDate_created_at = selectedDate;

                _fromDateText.text =
                    DateFormat("dd/MM/yyyy").format(selectedDate).toString();
                widget.filterScreenModel.filterModel.createdAt = "${DateFormat("dd/MM/yyyy").format(_fromDate)} - ${DateFormat("dd/MM/yyyy").format(_toDate)}";
                print(widget.filterScreenModel.filterModel.createdAt);
                LeadNavigator.pop(context);
              },
              haveBnConfirm: true,
            ),
          );
        });
  }

  _showToDatePickerCreateDate() {
    DateTime selectedDate = _toDate ?? _now;
    DateTime maximumTime = _now;
    if (_toDate.year == _now.year &&
        _toDate.month == _now.month &&
        _toDate.day > _now.day) maximumTime = _toDate;
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: CustomMenuBottomSheet(
              title: AppLocalizations.text(LangKey.toDate),
              widget: CustomDatePicker(
                initTime: selectedDate,
                maximumTime: maximumTime,
                minimumTime: _fromDate,
                dateOrder: DatePickerDateOrder.dmy,
                onChange: (DateTime date) {
                  selectedDate = date;
                },
              ),
              onTapConfirm: () {
                _toDate = selectedDate;
                widget.filterScreenModel.toDate_created_at = selectedDate;
                _toDateText.text =
                    DateFormat("dd/MM/yyyy").format(selectedDate).toString();
                widget.filterScreenModel.filterModel.createdAt = "${DateFormat("dd/MM/yyyy").format(_fromDate ?? _toDate ?? _now)} - ${DateFormat("dd/MM/yyyy").format(_toDate)}";
                print(widget.filterScreenModel.filterModel.createdAt);
                LeadNavigator.pop(context);
              },
              haveBnConfirm: true,
            ),
          );
        });
  }

  Widget _buildDatePicker(
      String hintText, TextEditingController fillText, Function ontap) {
    return InkWell(
      onTap: ontap,
      child: TextField(
        enabled: false,
        controller: fillText,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.all(12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(width: 1, color: Color(0xFFB8BFC9)),
          // ),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 14.0,
              color: Color(0xFF8E8E8E),
              fontWeight: FontWeight.normal),
          isDense: true,
        ),
        // },
      ),
    );
  }

  Widget _optionItem(String name, bool selected, Function ontap) {
    return InkWell(
      onTap: ontap,
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
                      name,
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
                      name,
                      style: TextStyle(color: Color(0xFF8E8E8E)),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  selectedSource(int index) async {
    if (index != 6) {
      widget.filterScreenModel.fromDate_created_at = null;
      widget.filterScreenModel.toDate_created_at = null;
    }  
    List<CreateDateModel> models = widget.createDateOptions;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;
    creatDateSeleted = models[index];
    switch (index) {
      case 0:
      widget.filterScreenModel.filterModel.createdAt = "${DateFormat("dd/MM/yyyy").format(_now)} - ${DateFormat("dd/MM/yyyy").format(_now)}";

      widget.filterScreenModel.id_created_at = "${index}";
      print(widget.filterScreenModel.filterModel.createdAt);
        break;
      case 1:
        widget.filterScreenModel.filterModel.createdAt = "${DateFormat("dd/MM/yyyy").format(_now.subtract( Duration(days: 1)))} - ${DateFormat("dd/MM/yyyy").format(_now.subtract(Duration(days: 1)))}";
         print(widget.filterScreenModel.filterModel.createdAt);
         widget.filterScreenModel.id_created_at = "${index}";
        break;
      case 2:
        widget.filterScreenModel.filterModel.createdAt = "${DateFormat("dd/MM/yyyy").format(_now.subtract( Duration(days: 7)))} - ${DateFormat("dd/MM/yyyy").format(_now)}";
         print(widget.filterScreenModel.filterModel.createdAt);
         widget.filterScreenModel.id_created_at = "${index}";
        break;
      case 3:
        widget.filterScreenModel.filterModel.createdAt = "${DateFormat("dd/MM/yyyy").format(_now.subtract( Duration(days: 31)))} - ${DateFormat("dd/MM/yyyy").format(_now.subtract(Duration(days: 1)))}";
         print(widget.filterScreenModel.filterModel.createdAt);
         widget.filterScreenModel.id_created_at = "${index}";
        break;
      case 4:
        widget.filterScreenModel.filterModel.createdAt = "${DateFormat("dd/MM/yyyy").format(DateTime.parse(DateTime(_now.year, _now.month, 1).toString()))} - ${DateFormat("dd/MM/yyyy").format(DateTime.parse(DateTime(_now.year, _now.month +1, 0).toString()))}";
         print(widget.filterScreenModel.filterModel.createdAt);
         widget.filterScreenModel.id_created_at = "${index}";
        break;
      case 5:
       var lastmonth = _now.month - 1;
        widget.filterScreenModel.filterModel.createdAt = "${DateFormat("dd/MM/yyyy").format(DateTime.parse(DateTime(_now.year, _now.month - 1, 1).toString()))} - ${DateFormat("dd/MM/yyyy").format(DateTime.parse(DateTime(_now.year, lastmonth +1, 0).toString()))}";
         print(widget.filterScreenModel.filterModel.createdAt);
         widget.filterScreenModel.id_created_at = "${index}";
        break;
      case 6:
        widget.filterScreenModel.filterModel.createdAt = "";
      widget.filterScreenModel.id_created_at = "${index}";
        break;
      default:
    }

    setState(() {});
  }
}
