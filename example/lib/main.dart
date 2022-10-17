import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/lead_plugin_epoint.dart';

void main() {
  runApp(MaterialApp(
    locale: const Locale('vi','VN'),
    title: 'Navigation Basics',
    debugShowCheckedModeBanner: false,
    home:  MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.locale}) : super(key: key);
final Locale locale;
  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
   @override
  void initState() {
    super.initState();
    // LeadPluginEpoint.openLead(context, const Locale('vi','VN'));

    LeadPluginEpoint.open(context,const Locale(LangKey.langVi, 'VN'), 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3N0YWZmLWFwaS5zdGFnLmVwb2ludHMudm4vdXNlci9sb2dpbiIsImlhdCI6MTY2NTk3MjA0NywiZXhwIjoxNjY1OTkzNjQ3LCJuYmYiOjE2NjU5NzIwNDcsImp0aSI6IkZCOVFldHhSOENRNDFRMW4iLCJzdWIiOjEsInBydiI6ImEwZjNlNzRiZWRmNTEyYzQ3NzgyOTdkZTVmOTIwODZkYWQzOWNhOWYiLCJzaWQiOiJhZG1pbkBwaW9hcHBzLnZuIiwiYnJhbmRfY29kZSI6InFjIn0.gHAP7fmQfU4QQr2l_finNhmBddJqbWY9p6gCiHx4874',
     domain: 'https://staff-api.stag.epoints.vn', brandCode: 'qc');
  }

  @override
  Widget build(BuildContext context) {
    return Container(decoration: const BoxDecoration(
      color: Colors.white
    ),);
  }

}
