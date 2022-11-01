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
           var result = await LeadPluginEpoint.open(context,const Locale(LangKey.langVi, 'VN'), 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3N0YWZmLWFwaS5zdGFnLmVwb2ludHMudm4vdXNlci9sb2dpbiIsImlhdCI6MTY2NzI4ODkzNywiZXhwIjoxNjY3MzEwNTM3LCJuYmYiOjE2NjcyODg5MzcsImp0aSI6IjN3RHR3aTg4bTdRcXE2SnkiLCJzdWIiOjEsInBydiI6ImEwZjNlNzRiZWRmNTEyYzQ3NzgyOTdkZTVmOTIwODZkYWQzOWNhOWYiLCJzaWQiOiJhZG1pbkBwaW9hcHBzLnZuIiwiYnJhbmRfY29kZSI6InFjIn0.ZIiHhW2GLxPJ5tOZPykR8UHVfD3HWo8AUDb3yf1Vyzw',
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
