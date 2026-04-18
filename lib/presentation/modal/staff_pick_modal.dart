import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class StaffPickModal extends StatefulWidget {
  final List<WorkListStaffModel>? staffs;
  final WorkListStaffModel? selected;
  const StaffPickModal({Key? key, this.staffs, this.selected}) : super(key: key);

  @override
  State<StaffPickModal> createState() => _StaffPickModalState();
}

class _StaffPickModalState extends State<StaffPickModal> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchText = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<WorkListStaffModel> _all = [];
  List<WorkListStaffModel> _filtered = [];

  @override
  void initState() {
    super.initState();
    _all = widget.staffs ?? [];
    for (var s in _all) {
      s.isSelected = (widget.selected != null &&
          s.staffId == widget.selected!.staffId);
    }
    _filtered = List.of(_all);
  }

  void _search(String value) {
    if (value.isEmpty) {
      _filtered = List.of(_all);
    } else {
      final keys = value.removeAccents().split(" ");
      _filtered = _all.where((s) {
        final name = (s.staffName ?? "").removeAccents();
        return keys.every((k) => name.contains(k));
      }).toList();
    }
    setState(() {});
  }

  void _select(WorkListStaffModel staff) {
    Navigator.of(context).pop(staff);
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
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.clear, size: 15.0),
                  ),
                ),
                Text(
                  AppLocalizations.text(LangKey.chooseAllottedPerson)!,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                Container(width: 30),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchText,
              focusNode: _focusNode,
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.all(12.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xFFB8BFC9))),
                hintText: AppLocalizations.text(LangKey.inputSearch),
                isDense: true,
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? CustomDataNotFound()
                : CustomListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        top: 16.0, bottom: 16.0, left: 16.0, right: 8.0),
                    physics: ClampingScrollPhysics(),
                    controller: _controller,
                    separator: Divider(),
                    children: _filtered.map(_buildItem).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(WorkListStaffModel staff) {
    final selected = staff.isSelected ?? false;
    return InkWell(
      onTap: () => _select(staff),
      child: Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                staff.staffName ?? "",
                style: TextStyle(
                    fontSize: 15.0,
                    color: selected
                        ? AppColors.primaryColor
                        : Color(0xFF040C21),
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400),
              ),
            ),
            if (selected)
              Icon(Icons.check, color: AppColors.primaryColor, size: 20),
          ],
        ),
      ),
    );
  }
}
