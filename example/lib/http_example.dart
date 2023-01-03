 
 
//  import 'package:http/http.dart' as http;
//  import 'dart:convert';

// class HTTPConnection {
 
//  Future<ResponseData>post(String path, Map<String, dynamic> body) async {
//     // final uri = Uri.parse('$domain$path');
//     final headers = {'Content-Type': 'application/json','brand-code':"qc", 'lang': "vi"};
//     // if(LeadConnection.account != null) {
//       // headers['Authorization'] = 'Bearer ${LeadConnection.account.accessToken}';
//       // headers['Authorization'] = 'Bearer ${asscessToken}';
//     // }
//     String jsonBody = json.encode(body);
//     if (kDebugMode) {
//       print('***** POST *****');
//       print(uri);
//       print(headers);
//       print(jsonBody);
//       print('***** POST *****');
//     }
//     final encoding = Encoding.getByName('utf-8');
//     http.Response response = await http.post(
//       uri,
//       headers: headers,
//       body: jsonBody,
//       encoding: encoding,
//     );
//     int statusCode = response.statusCode;
//     print(response);
//     if(statusCode == 200) {
//       ResponseData data = ResponseData();
//       data.isSuccess = true;
//       try {
//         String responseBody = response.body;
//         data.data = jsonDecode(responseBody);
//       }catch(_) {}
//       return data;
//     }
//     else if( 201 <= statusCode && statusCode < 300) {
//       ResponseData data = ResponseData();
//       data.isSuccess = true;
//       return data;
//     }
//     else {
//       ResponseData data = ResponseData();
//       data.isSuccess = false;
//       try {
//         String responseBody = response.body;
//         data.data = jsonDecode(responseBody);
//       }catch(_) {}
//       return data;
     
//     }
//   }
//  }

//  class ResponseData {
//    bool isSuccess;
//    Map<String,dynamic> data;
//    List<dynamic> datas;
// }
