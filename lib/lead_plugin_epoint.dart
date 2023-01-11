import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/http_connection.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/comment_screen/ui/comment_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/create_potential_customer.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/detail_potential_customer.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/edit_potential_customer/edit_potential_customer.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/list_screen/list_potential_customer.dart';
import 'package:lead_plugin_epoint/utils/global.dart';

import 'common/localization/app_localizations.dart';
import 'lead_plugin_epoint_platform_interface.dart';

class LeadPluginEpoint {
  Future<String> getPlatformVersion() {
    return LeadPluginEpointPlatform.instance.getPlatformVersion();
  }

  static Future<Future<Object>> openLead(
      BuildContext context, Locale locale) async {
    // await AppSizes.init(context);
    await AppLocalizations(locale).load();

    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LeadScreen()));
  }

  static Future<dynamic> open(
      BuildContext context, Locale locale, String token, int create,
      {String domain,
      String brandCode,
      String fullname,
      String phone,
      String customerLeadCode,
      Function createJob,
      Function editJob,
      Function openDetailDeal}) async {
    if (domain != null) {
      HTTPConnection.domain = domain;
    }
    if (brandCode != null) {
      HTTPConnection.brandCode = brandCode;
    }
    if (token != null) {
      HTTPConnection.asscessToken = token;
    }
    if (createJob != null) {
      Global.createJob = createJob;
    }

    if (editJob != null) {
      Global.editJob = editJob;
    }

    if (openDetailDeal != null) {
      Global.openDetailDeal = openDetailDeal;
    }

    LeadConnection.locale = locale;
    LeadConnection.buildContext = context;
    AppSizes.init(context);
    await AppLocalizations(LeadConnection.locale).load();
    bool result = await LeadConnection.init(token, domain: domain);
    if (result) {
      if (create == 0) {
        Map<String, dynamic> event = await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => CreatePotentialCustomer(
                    fullname: fullname, phoneNumber: phone)));
        return event;
      } else if (create == 1) {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                DetailPotentialCustomer(customer_lead_code: customerLeadCode)));
        return null;
      } else if (create == 3) {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                EditPotentialCustomer(customer_lead_code: "LEAD_29122022233")));
      } else {
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LeadScreen()));
        return null;
      }
    } else {
      loginError(LeadConnection.buildContext, 'Fail');
      return null;
    }
  }

  static void loginError(BuildContext context, String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title:  Text(''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Text(
                  'Cảnh báo\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                )),
                Center(child: Text(title)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text('Đồng ý')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
