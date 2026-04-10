import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lead_plugin_epoint/common/constant.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/response/get_branch_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/widget/container_scrollable.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<KeyboardActionsItem>? actions;
  final String? title;
  final Widget? body;
  final CustomRefreshCallback? onRefresh;
  final bool? isBottomSheet;

  CustomBottomSheet(
      {this.actions,
      this.title,
      this.body,
      this.onRefresh,
      this.isBottomSheet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // actions: actions,
      // isBottomSheet: isBottomSheet ?? true,
      body: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: MediaQuery.of(context).padding.top + 15.0,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: InkWell(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Container(
                          width: 40.0,
                          height: 4.0,
                          decoration: BoxDecoration(
                              color: Color(0xFFC4C4C4),
                              borderRadius: BorderRadius.circular(100.0)),
                        ),
                      ),
                      title == null
                          ? Container()
                          : Container(
                              height: kToolbarHeight,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xFFECECEC)))),
                              child: Row(
                                children: [
                                  InkWell(
                                    child: Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                        size: 20.0,
                                      ),
                                    ),
                                    onTap: () => Navigator.pop(context),
                                  ),
                                  Expanded(
                                    child: Text(
                                      title!,
                                      style: TextStyle(
                                          fontSize: AppTextSizes.size17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    width: 40.0,
                                  )
                                ],
                              ),
                            ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: onRefresh == null
                            ? (body ?? Container())
                            : ContainerScrollable(
                                child: body ?? Container(),
                                onRefresh: onRefresh),
                      )
                    ],
                  ),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}

class SearchableStaffBottomSheet extends StatefulWidget {
  final String? title;
  final List<WorkListStaffModel> staffs;
  final String hintText;

  const SearchableStaffBottomSheet({
    super.key,
    this.title,
    required this.staffs,
    this.hintText = 'Search staff',
  });

  @override
  State<SearchableStaffBottomSheet> createState() =>
      _SearchableStaffBottomSheetState();
}

class _SearchableStaffBottomSheetState
    extends State<SearchableStaffBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<WorkListStaffModel> _filteredStaffs;

  @override
  void initState() {
    super.initState();
    _filteredStaffs = widget.staffs;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStaffs = widget.staffs
          .where(
              (staff) => (staff.staffName ?? '').toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 100),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _filteredStaffs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final staff = _filteredStaffs[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryColor
                          .withValues(alpha: 0.1),
                      backgroundImage: (staff.staffAvatar != null &&
                              staff.staffAvatar!.isNotEmpty)
                          ? NetworkImage(staff.staffAvatar!)
                          : null,
                      child: (staff.staffAvatar == null ||
                              staff.staffAvatar!.isEmpty)
                          ? Icon(Icons.person,
                              color: AppColors.primaryColor)
                          : null,
                    ),
                    title: Text(
                      staff.staffName ?? '',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    subtitle: (staff.departmentName != null &&
                            staff.departmentName!.isNotEmpty)
                        ? Text(
                            staff.departmentName!,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600),
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(context, staff);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchableBranchBottomSheet extends StatefulWidget {
  final String? title;
  final List<BranchData> branches;
  final String hintText;

  const SearchableBranchBottomSheet({
    super.key,
    this.title,
    required this.branches,
    this.hintText = 'Search branch',
  });

  @override
  State<SearchableBranchBottomSheet> createState() =>
      _SearchableBranchBottomSheetState();
}

class _SearchableBranchBottomSheetState
    extends State<SearchableBranchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<BranchData> _filteredBranches;

  @override
  void initState() {
    super.initState();
    _filteredBranches = widget.branches;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBranches = widget.branches
          .where((branch) =>
              (branch.branchName ?? '').toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 100),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _filteredBranches.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final branch = _filteredBranches[index];
                  return ListTile(
                    title: Text(
                      branch.branchName ?? '',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    subtitle: (branch.address != null &&
                            branch.address!.isNotEmpty)
                        ? Text(
                            branch.address!,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(context, branch);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
