import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

/// Generic multi-select bottom sheet for filter screen.
///
/// Rendered via `showModalBottomSheet` and returns the same list passed in,
/// with the `selected` flag of each item mutated in-place. Callers should
/// treat a non-null result as "user confirmed".
class FilterMultiSelectBottomSheet<T> extends StatefulWidget {
  /// Full list of selectable items.
  final List<T>? items;

  /// Title shown at the top of the sheet.
  final String? title;

  /// Extract display text from an item.
  final String Function(T item) labelOf;

  /// Read current selected state from an item.
  final bool Function(T item) isSelectedOf;

  /// Toggle selected state on an item.
  final void Function(T item) toggleSelected;

  const FilterMultiSelectBottomSheet({
    Key? key,
    required this.items,
    required this.title,
    required this.labelOf,
    required this.isSelectedOf,
    required this.toggleSelected,
  }) : super(key: key);

  @override
  State<FilterMultiSelectBottomSheet<T>> createState() =>
      _FilterMultiSelectBottomSheetState<T>();
}

class _FilterMultiSelectBottomSheetState<T>
    extends State<FilterMultiSelectBottomSheet<T>> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<T> _displayItems = [];

  @override
  void initState() {
    super.initState();
    _displayItems = List<T>.from(widget.items ?? []);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _search(String value) {
    final source = widget.items ?? [];
    if (value.isEmpty) {
      setState(() => _displayItems = List<T>.from(source));
      return;
    }
    try {
      final terms = value.removeAccents().split(" ");
      final result = source.where((item) {
        final label = widget.labelOf(item).removeAccents();
        for (final term in terms) {
          if (!label.contains(term)) return false;
        }
        return true;
      }).toList();
      setState(() => _displayItems = result);
    } catch (_) {
      setState(() {});
    }
  }

  void _onConfirm() {
    Navigator.of(context).pop(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: _buildSearch(),
            ),
            Expanded(child: _buildList()),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: CustomButton(
                text: AppLocalizations.text(LangKey.confirm),
                ontap: _onConfirm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 48.0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Text(
              widget.title ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const SizedBox(
            width: 48.0,
            height: 48.0,
            child: Icon(Icons.clear, color: Colors.black, size: 20.0),
          ),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocus,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: const EdgeInsets.all(12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Color(0xFFB8BFC9)),
        ),
        hintText: AppLocalizations.text(LangKey.inputSearch),
        isDense: true,
      ),
      onChanged: _search,
    );
  }

  Widget _buildList() {
    if (_displayItems.isEmpty) {
      return const CustomDataNotFound();
    }
    return CustomListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      separator: const Divider(),
      children: _displayItems.map((item) => _buildItem(item)).toList(),
    );
  }

  Widget _buildItem(T item) {
    final selected = widget.isSelectedOf(item);
    return InkWell(
      onTap: () {
        widget.toggleSelected(item);
        setState(() {});
      },
      child: SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.labelOf(item),
                style: TextStyle(
                  fontSize: 15.0,
                  color: selected ? AppColors.primaryColor : Colors.black,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              selected ? Icons.check_box : Icons.check_box_outline_blank,
              color: selected
                  ? AppColors.primaryColor
                  : const Color.fromARGB(255, 108, 102, 94),
            ),
          ],
        ),
      ),
    );
  }
}
