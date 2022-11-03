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
  }

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
      child: InkWell(
        child: Text("Open lead"),
        onTap: () async {
           var result = await LeadPluginEpoint.open(context,const Locale(LangKey.langVi, 'VN'), 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3N0YWZmLWFwaS5zdGFnLmVwb2ludHMudm4vdXNlci9sb2dpbiIsImlhdCI6MTY2NzQ2ODc1OSwiZXhwIjoxNjY3NDkwMzU5LCJuYmYiOjE2Njc0Njg3NTksImp0aSI6IkI3WVFOMldLWHZDeDk3amMiLCJzdWIiOjEsInBydiI6ImEwZjNlNzRiZWRmNTEyYzQ3NzgyOTdkZTVmOTIwODZkYWQzOWNhOWYiLCJzaWQiOiJhZG1pbkBwaW9hcHBzLnZuIiwiYnJhbmRfY29kZSI6InFjIn0.EnL_cwoek63hIE3fFG9J6-6COBb7rTGzjdOUQ3ElqMo',
           2,
     domain: 'https://staff-api.stag.epoints.vn', brandCode: 'qc');

     if (result != null) {

       print(result);
     }
        },
      ),
    ),
      ),
    );
  }

}
