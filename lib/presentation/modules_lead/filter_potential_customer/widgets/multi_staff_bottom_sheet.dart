import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/multi_staff_screen_customer_care/ui/multi_staff_screen_customer_care.dart';

/// Bottom sheet wrapper around [MultipleStaffScreenCustomerCare].
///
/// Reuses the original screen with `hideAppBar: true` so we don't duplicate
/// its search / branch-department filter / multi-select / confirm logic.
/// Renders a plain white header (title + close button) in place of the
/// original blue `AppBar`.
class MultiStaffBottomSheet extends StatelessWidget {
  final List<WorkListStaffModel>? models;

  const MultiStaffBottomSheet({Key? key, this.models}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.1,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildHeader(context),
              const Divider(height: 1),
              Expanded(
                child: MultipleStaffScreenCustomerCare(
                  models: models,
                  hideAppBar: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 48.0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Text(
              AppLocalizations.text(LangKey.chooseAllottedPerson) ?? "",
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
}
