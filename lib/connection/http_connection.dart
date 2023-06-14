import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lead_plugin_epoint/connection/lead_connection.dart';

class HTTPConnection {
  // static String domain = 'https://staff-api.stag.epoints.vn';
  // static String brandCode = 'qc';
  // static String asscessToken = '';

  static String domain = '';
  static String brandCode = '';
  static String asscessToken = '';

  Future<ResponseData> upload(String path, MultipartFileModel model) async {
    final uri = Uri.parse('$domain$path');
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({'Content-Type': 'multipart/form-data','Authorization':'Bearer ${asscessToken}','brand-code':brandCode, 'lang': LeadConnection.locale!.languageCode, 'branch-id':'1'});
    request.files.add(
      http.MultipartFile(
        model.name!,
        model.file!.readAsBytes().asStream(),
        model.file!.lengthSync(),
        filename: model.file!.path.split("/").last,
      ),
    );
    if (kDebugMode) {
      print('***** Upload *****');
      print(uri);
      print(request.headers);
      print('***** Upload *****');
    }
    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if(response.statusCode == 200) {
      print(response.body);
      ResponseData data = ResponseData();
      data.isSuccess = true;
      try {
        String responseBody = response.body;
        data.data = jsonDecode(responseBody);
      }catch(_) {}
      return data;
    }
    else {
      ResponseData data = ResponseData();
      data.isSuccess = false;
      try {
        String responseBody = response.body;
        data.data = jsonDecode(responseBody);
      }catch(_) {}
      return data;
    }
  }

//  Future<Map<String, String>> _headers(Map<String, String> content) async {
//     Map<String, String> headers = {
//       HttpHeaders.contentTypeHeader: listFile == null ? _typeApplication : _typeMultipart,
//       "lang": Globals.prefs.getString(SharedPrefsKey.language, value: null) ?? LangKey.langDefault
//     };

//     if(!(emptyHeader ?? false)){
//       String token = Globals.prefs.getString(tokenKey);
//       if (token != "")
//         headers[HttpHeaders.authorizationHeader] = "Bearer " + token;

//       String brandCode = Globals.prefs.getString(SharedPrefsKey.brand_code, value: Globals.config.clientKey);
//       if (brandCode != ""){
//         if(showBrandCode){
//           headers["brand-code"] = brandCode;
//         }
//         headers["client-key"] = brandCode;
//       }

//       if(Globals.model != null){
//         headers["branch-id"] = (Globals.model.branchId ?? 0).toString();
//       }
//     }

//     if (content != null) {
//       content.forEach((key, value) {
//         headers[key] = value;
//       });
//     }

//     return headers;
//   }


  
  Future<ResponseData>post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$domain$path');
    final headers = {'Content-Type': 'application/json','brand-code':brandCode, 'lang': LeadConnection.locale!.languageCode};
    // if(LeadConnection.account != null) {
      // headers['Authorization'] = 'Bearer ${LeadConnection.account.accessToken}';
      headers['Authorization'] = 'Bearer ${asscessToken}';
    // }
    String jsonBody = json.encode(body);
    if (kDebugMode) {
      print('***** POST *****');
      print(uri);
      print(headers);
      print(jsonBody);
      print('***** POST *****');
    }
    final encoding = Encoding.getByName('utf-8');
    http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    int statusCode = response.statusCode;
    print(response);
    if(statusCode == 200) {
      ResponseData data = ResponseData();
      data.isSuccess = true;
      try {
        String responseBody = response.body;
        data.data = jsonDecode(responseBody);
      }catch(_) {}
      return data;
    }
    else if( 201 <= statusCode && statusCode < 300) {
      ResponseData data = ResponseData();
      data.isSuccess = true;
      return data;
    }
    else {
      ResponseData data = ResponseData();
      data.isSuccess = false;
      try {
        String responseBody = response.body;
        data.data = jsonDecode(responseBody);
      }catch(_) {}
      return data;
     
    }
  }



 
}

class ResponseData {
   late bool isSuccess;
   Map<String,dynamic>? data;
   List<dynamic>? datas;
}

class MultipartFileModel {
  File? file;
  String? name;

  MultipartFileModel({this.file, this.name});

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
     data['file'] = this.file;
    data['name'] = this.name;
    return data;
  }
}

