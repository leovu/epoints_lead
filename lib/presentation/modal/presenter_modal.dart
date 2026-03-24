import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/response/customer_response_model.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_item_bottom_sheet.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_menu_bottom_sheet.dart';

class PresenterModal extends StatefulWidget {
  final List<CustomerModel> customers;
  final CustomerModel? selected;
  const PresenterModal({Key? key, required this.customers, this.selected})
      : super(key: key);

  @override
  _PresenterModalState createState() => _PresenterModalState();
}

class _PresenterModalState extends State<PresenterModal> {
  final TextEditingController _searchController = TextEditingController();
  List<CustomerModel> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = List.from(widget.customers);
  }

  void _onSearch(String value) {
    if (value.trim().isEmpty) {
      _filtered = List.from(widget.customers);
    } else {
      final q = value.trim().removeAccents().toLowerCase();
      _filtered = widget.customers.where((c) {
        return (c.fullName ?? '').removeAccents().toLowerCase().contains(q) ||
            (c.phone ?? '').contains(q);
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomMenuBottomSheet(
      title: AppLocalizations.text(LangKey.presenter),
      haveBnConfirm: false,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            onChanged: _onSearch,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.all(12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Color(0xFFB8BFC9)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: AppLocalizations.text(LangKey.inputSearch),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(Assets.iconSearch),
              ),
              suffixIconConstraints:
                  const BoxConstraints(maxHeight: 40.0, maxWidth: 40.0),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 350),
            child: _filtered.isEmpty
                ? CustomDataNotFound()
                : CustomListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: _filtered
                        .asMap()
                        .map((index, item) => MapEntry(
                              index,
                              CustomItemBottomSheet(
                                item.fullName ?? '',
                                () => Navigator.of(context).pop(item),
                                subText: item.phone,
                                isBorder: index < _filtered.length - 1,
                                isSelected:
                                    item.customerId == widget.selected?.customerId,
                              ),
                            ))
                        .values
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
