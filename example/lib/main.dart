import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/lead_plugin_epoint.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(MaterialApp(
    locale: const Locale('vi', 'VN'),
    title: 'Navigation Basics',
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
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
          title: const Text('Lead plugin'),
        ),
        body: Center(
          child: InkWell(
            onTap: () async {
              var result = await LeadPluginEpoint.open(
                  branchId: 1,
                  staffId: 230,
                  context,
                  Locale(LangKey.langVi, 'vi'),
                  'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3N0YWZmLWFwaS1zdGFnLmVwb2ludHMudm4vdXNlci9sb2dpbiIsImlhdCI6MTc3ODczMzQxNCwiZXhwIjoxNzc4NzU1MDE0LCJuYmYiOjE3Nzg3MzM0MTQsImp0aSI6Im9UeWpjbWxSUkZrMjNKTVQiLCJzdWIiOjIzMCwicHJ2IjoiYTBmM2U3NGJlZGY1MTJjNDc3ODI5N2RlNWY5MjA4NmRhZDM5Y2E5ZiIsInNpZCI6InF1YW5nbWwiLCJicmFuZF9jb2RlIjoicWMifQ.aI5kLw-dJ01bYTngPfcqTIT3vpn-Kh5EL_L0T9XMuTc',
                  2,
                  domain: 'https://staff-api.stag.epoints.vn',
                  brandCode: 'qc');

              if (result != null) {}
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(249, 249, 64, 2),
                  borderRadius: BorderRadius.circular(10)),
              height: 40,
              width: MediaQuery.of(context).size.width / 2,
              child: Center(child: Text("Open lead")),
            ),
          ),
        ),
      ),
    );
  }
}
