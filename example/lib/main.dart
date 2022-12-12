import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/lead_plugin_epoint.dart';

void main() {
  runApp(MaterialApp(
    locale: const Locale('vi', 'VN'),
    title: 'Navigation Basics',
    debugShowCheckedModeBanner: false,
    
    home: MyApp(),
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
          child: Container(
            decoration: BoxDecoration( 
                color: Color.fromARGB(249, 249, 64, 2),
                borderRadius: BorderRadius.circular(10)),
            height: 40,
            width: MediaQuery.of(context).size.width / 2,
            child: Center(
              child: InkWell(
                child: Text("Open lead"),
                onTap: () async {
                  var result = await LeadPluginEpoint.open(
                      context,
                      const Locale(LangKey.langVi, 'VN'),
                      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vc3RhZmYtYXBpLnN0YWcuZXBvaW50cy52bi91c2VyL2xvZ2luIiwiaWF0IjoxNjcwODExNDcxLCJleHAiOjE2NzA4MzMwNzEsIm5iZiI6MTY3MDgxMTQ3MSwianRpIjoiUGh1UnpQQm91QkR0cWFyYiIsInN1YiI6MSwicHJ2IjoiYTBmM2U3NGJlZGY1MTJjNDc3ODI5N2RlNWY5MjA4NmRhZDM5Y2E5ZiIsInNpZCI6ImFkbWluQHBpb2FwcHMudm4iLCJicmFuZF9jb2RlIjoicWMifQ.dACMOOMWI5Dw6fx5u1EnqLJEpk9dhw-ZX-KU4YXilXc',
                      2,
                      domain: 'https://staff-api.stag.epoints.vn',
                      brandCode: 'qc');

                  if (result != null) {}
                },
              ),
            ),
          ),
        ),
        floatingActionButton: DraggableFab(
          securityBottom: -5,
        child: FloatingActionButton(
          onPressed: () {
            print("keo");
          },
          child: Icon(Icons.add),
        ),
      ),
      ),
    );
  }
}


// import 'dart:io' as io;
// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:salesiq_mobilisten/salesiq_mobilisten.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//     initMobilisten();
//   }

//   Future<void> initMobilisten() async {
//     if (io.Platform.isIOS || io.Platform.isAndroid) {
//       String appKey;
//       String accessKey;
//       if (io.Platform.isIOS) {
//         appKey = "EtzmN6YYkoybb%2FWmfEtMUIT2jS0cVRMaE8IA0L0udBo%3D";
//         accessKey = "dU6CFehEs80y0jcz0o7B3nvp8CidTijd5CiEgy5fyo5kltXAnEnrCVUuCXPmQSe7q1WkU0uxOTQkNLmR0xFHzbB3NBeHf2mgdrzElerQsMyEuSoGXAJjSxdjp5vHW7FhPFhjL367TwelYT218Ogo8cr6mhMDscv1ud3cxli2xGYwm04Gs7ytKg%3D%3D";
//       } else {
//         appKey = "INSERT_ANDROID_APP_KEY";
//         accessKey = "INSERT_ANDROID_ACCESS_KEY";
//       }
//       ZohoSalesIQ.init(appKey, accessKey).then((_) {
//         // initialization successful

//         ZohoSalesIQ.showLauncher(true);
        
//       }).catchError((error) {
//         // initialization failed
//         print(error);
//       });
//       ZohoSalesIQ.setThemeColorForiOS("#6d85fc");
//     }
//   }

//   Future<void> initPlatformState() async {
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Example Application'),
//           ),
//           body: Center(child: Column(children: <Widget>[]))),
//     );
//   }
// }


