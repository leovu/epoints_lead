
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/connection/http_connection.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/create_potential_customer.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/list_screen/list_potential_customer.dart';
import 'package:lead_plugin_epoint/utils/navigator.dart';
import 'common/localization/app_localizations.dart';
import 'lead_plugin_epoint_platform_interface.dart';

class LeadPluginEpoint {
  Future<String> getPlatformVersion() {
    return LeadPluginEpointPlatform.instance.getPlatformVersion();
  }
  static Future<Future<Object>> openLead(BuildContext context, Locale locale) async {

    // await AppSizes.init(context);
    await AppLocalizations(locale).load();

    return LeadNavigator.push(context, LeadScreen());

  }

  static Future <Map<String, dynamic>> open (BuildContext context, Locale locale,String token, int create, {String domain, String brandCode}) async {
    if(domain != null) {
      HTTPConnection.domain = domain;
    }
    if(brandCode != null) {
      HTTPConnection.brandCode = brandCode;
    }
    if(token != null) {
      HTTPConnection.asscessToken = token;
    }

    LeadConnection.locale = locale;
    LeadConnection.buildContext = context;
    await AppLocalizations(LeadConnection.locale).load();
    bool result = await LeadConnection.init(token,domain: domain);

    Navigator.of(LeadConnection.buildContext).pop();
    if(result) {
      // await Navigator.of(LeadConnection.buildContext,rootNavigator: true).push(
          // MaterialPageRoute(builder: (context) =>  AppDocument(),settings: const RouteSettings(name: 'folder_management_screen')));
    // await LeadNavigator.push(context, CreatePotentialCustomer());

    if (create == 0 ) {
     Map<String, dynamic> result =  await LeadNavigator.push(context, CreatePotentialCustomer());
     return result;
    } else {
       await LeadNavigator.push(context, LeadScreen());
    }
    }else {
      loginError(LeadConnection.buildContext, 'Fail');
    }
    return null;
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
