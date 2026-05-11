import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/lead_plugin_epoint.dart';

void main() {
  runApp(MaterialApp(
    locale: const Locale('en', 'AU'),
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

//1.0.10
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
                context,
                const Locale('en', 'EN'),
                'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3N0YWZmLWFwaS5kZXYubWF0dGhld3NsaXF1b3IuY29tLmF1Ly91c2VyL2xvZ2luIiwiaWF0IjoxNzc4NDkxNDE2LCJleHAiOjE3Nzg1MTMwMTYsIm5iZiI6MTc3ODQ5MTQxNiwianRpIjoiNmRqdFNXTmgxTXRQMXIwSiIsInN1YiI6MjA3LCJwcnYiOiJhMGYzZTc0YmVkZjUxMmM0Nzc4Mjk3ZGU1ZjkyMDg2ZGFkMzljYTlmIiwic2lkIjoiYWRtaW5AbWF0dGhld3NsaXF1b3IuY29tIiwicGhvbmUiOiJhZG1pbkBtYXR0aGV3c2xpcXVvci5jb20iLCJicmFuZF9jb2RlIjoibWF0dGhld3NsaXF1b3IiLCJpbWVpIjoiNDI2NzhkM2RkNjBlM2ZiYyJ9.3NLRqRqTCXKi8_-rsQ_O6RmytysQVTXwjivVHNxjz2c',
                2,
                domain: 'https://staff-api.dev.matthewsliquor.com.au',
                brandCode: 'matthewsliquor',
                phone: null,
                fullname: null,
                customerLeadCode: null,
                branchId: '16',
                userId: '207',
                permission: const [
                  {
                    'widget_id': 'LE000003',
                    'widget_name': '[App_Staff] Edit lead contact',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'LE000004',
                    'widget_name': '[App_Staff] Update lead referrer',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'OD000007',
                    'widget_name': 'View order image',
                    'is_hot_function': 0
                  },
                  {
                    'widget_id': 'OD000008',
                    'widget_name': 'Edit/Upload order image',
                    'is_hot_function': 0
                  },
                  {
                    'widget_id': 'OD000009',
                    'widget_name': 'View order info',
                    'is_hot_function': 0
                  },
                  {
                    'widget_id': 'CM000004',
                    'widget_name': '[App_Staff] View customer infomation',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'OD000001',
                    'widget_name': 'Create order',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'OD000002',
                    'widget_name': 'Order detail',
                    'is_hot_function': 0
                  },
                  {
                    'widget_id': 'OD000003',
                    'widget_name': 'Edit order',
                    'is_hot_function': 0
                  },
                  {
                    'widget_id': 'OD000004',
                    'widget_name': 'Order payment',
                    'is_hot_function': 0
                  },
                  {
                    'widget_id': 'OD000005',
                    'widget_name': 'Products',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'OD000000',
                    'widget_name': 'Orders',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'CM000001',
                    'widget_name': 'Create customer',
                    'is_hot_function': 0
                  },
                  {
                    'widget_id': 'CM000002',
                    'widget_name': 'Customer detail',
                    'is_hot_function': 0
                  },
                  {
                    'widget_id': 'CM000003',
                    'widget_name': 'Edit customer',
                    'is_hot_function': 0
                  },
                  {
                    'widget_id': 'CM000000',
                    'widget_name': 'Customers',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'WK000000',
                    'widget_name': '[App_Staff] Task magagement',
                    'is_hot_function': 0
                  },
                  {
                    'widget_id': 'WK000001',
                    'widget_name': 'My tasks',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'WK000002',
                    'widget_name': 'Task approval',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'WK000003',
                    'widget_name': 'Create a task',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'WK000004',
                    'widget_name': 'Task overview',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'WK000005',
                    'widget_name': 'Task list',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'WK000006',
                    'widget_name': 'Assigned by me',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'WK000007',
                    'widget_name': 'View reminders',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'TI000000',
                    'widget_name': 'Timekeeping',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'TI000001',
                    'widget_name': 'Timekeeping history',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'TI000002',
                    'widget_name': 'Report time working staff',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'CH000000',
                    'widget_name': 'Chat',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'SY00000',
                    'widget_name': 'Survey',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'SY000000',
                    'widget_name': 'Survey',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'AP000000',
                    'widget_name': 'My application',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'AP000001',
                    'widget_name': 'Create a spell',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'AP000002',
                    'widget_name': 'Approval of permit application',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'DO000000',
                    'widget_name': 'File management',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'CH000001',
                    'widget_name': 'Chat Hub',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'LE000000',
                    'widget_name': 'Customer lead',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'LE000001',
                    'widget_name': 'Add customer lead',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'DE000000',
                    'widget_name': 'Potential deals',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'PR000000',
                    'widget_name': 'Project Management',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'PR000001',
                    'widget_name': 'Add Project',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'DL000000',
                    'widget_name': 'Delivery',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'EX000000',
                    'widget_name': 'Warehouse dispatch',
                    'is_hot_function': 1
                  },
                  {
                    'widget_id': 'IM000000',
                    'widget_name': 'Warehouse receipt',
                    'is_hot_function': 1
                  },
                ],
              );
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


