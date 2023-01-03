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

  Future<ResponseData> upload(String path, File file) async {
    final uri = Uri.parse('$domain$path');
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({'Content-Type': 'multipart/form-data','Authorization':'Bearer ${asscessToken}','brand-code':brandCode, 'qc': LeadConnection.locale.languageCode});
    request.files.add(
      http.MultipartFile(
        'file_name',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path.split("/").last,
      ),
    );
    // if(body != null) {
    //   for (var key in body.keys) {
    //     request.fields[key] = body[key];
    //   }
    // }
    if (kDebugMode) {
      print('***** Upload *****');
      print(uri);
      print(request.headers);
      print('***** Upload *****');
    }
    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if(response.statusCode == 200) {
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

  //  Future<String> uploadImage(filepath, url) async {
  //   var request = http.MultipartRequest('POST', Uri.parse(url));
  //   request.files.add(http.MultipartFile('image',
  //       File(filepath).readAsBytes().asStream(), File(filepath).lengthSync(),
  //       filename: filepath.split("/").last));
  //   var res = await request.send();

    
  // }

  
  Future<ResponseData>post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$domain$path');
    final headers = {'Content-Type': 'application/json','brand-code':brandCode, 'lang': LeadConnection.locale.languageCode};
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
   bool isSuccess;
   Map<String,dynamic> data;
   List<dynamic> datas;
}

class MultipartFileModel {
  File file;
  String name;

  MultipartFileModel({this.file, this.name});

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
     data['file'] = this.file;
    data['name'] = this.name;
    return data;
  }
}

