

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/connection/http_connection.dart';
import 'package:lead_plugin_epoint/connection/network_connectivity.dart';
import 'package:lead_plugin_epoint/utils/global.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

abstract class HttpConnection<T> {
  final String _typeApplication = "application/json";
  final String _typeMultipart = "multipart/form-data";
  final String _typeUrlencoded = "application/x-www-form-urlencoded";
  final String _tag = "HttpConnection";
  final int _timeOut = 120;
  ApiConnectionMethod? _method;
  String? _fullURL;
  late bool _isJson;

  String get apiUrl;
  String? get baseUrl;
  Map<String, dynamic>? get bodyParam;
  Map<String, String>? get headerParam;
  List<MultipartFileModel>? get listFile;
  String get tokenKey;
  bool get showBrandCode;
  bool get emptyHeader;

  Future<Map<String, String>> _headers(Map<String, String>? content) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: listFile == null ? _typeApplication : _typeMultipart,
      "lang": LangKey.langDefault
    };

    if(!emptyHeader){
      String token = Global.asscessToken;
      if (token != "")
        headers[HttpHeaders.authorizationHeader] = "Bearer " + token;

      String brandCode = Global.brandCode;
      if (brandCode != ""){
        if(showBrandCode){
          headers["brand-code"] = brandCode;
        }
        headers["client-key"] = brandCode;
      }
    }

    if (content != null) {
      content.forEach((key, value) {
        headers[key] = value;
      });
    }

    return headers;
  }

  Future<T> retry(){
    if(_method == ApiConnectionMethod.GET){
      return get();
    }
    else if(_method == ApiConnectionMethod.POST){
      return post();
    }
    else{
      return getGoogleApi();
    }
  }

  Future<T> get() async {
    _method = ApiConnectionMethod.GET;

    String fullUrl = baseUrl! + apiUrl;

    if (bodyParam != null) {
      String body = "?";
      bodyParam!.forEach((key, value) {
        try {
          List<dynamic> values = value;
          values.forEach((data) {
            body = body + key + "=" + data.toString() + "&";
          });
        } catch (ex) {
          body = body + key + "=" + value.toString() + "&";
        }
      });
      body = body.substring(0, body.length - 1);
      fullUrl = fullUrl + body;
    }

    _fullURL = fullUrl;

    return await _handleConnection();
  }

  Future<T> post() async {
    _method = ApiConnectionMethod.POST;

    bool isJson = true;
    if (bodyParam == null)
      isJson = false;
    else {
      if (headerParam != null) {
        isJson = !headerParam!.values.contains(_typeUrlencoded);
      }
    }

    _fullURL = baseUrl! + apiUrl;
    _isJson = isJson;

    return await _handleConnection();
  }

  Future<T> getGoogleApi() async {
    _method = ApiConnectionMethod.GOOGLE;

    _fullURL = apiUrl;

    return _handleConnection();
  }

  Future<T?> _checkConnectivity() async {
    if (!(await NetworkConnectivity.isConnected())) {
      return getError(AppLocalizations.text(LangKey.connection_error));
    }
    return null;
  }

  Future<T> _handleConnection() async {
    T? data = await _checkConnectivity();
    if (data != null) {
      return await handleError(data);
    }

    Map<String, String?> finalHeader = await _headers(headerParam);

    customPrint("$_tag Method: $_method");
    customPrint("$_tag Url: $_fullURL");
    customPrint("$_tag Header: $finalHeader");

    Uri uri = Uri.parse(_fullURL!);

    var response;
    try {
      if (_method == ApiConnectionMethod.GET)
        response = await http
            .get(uri, headers: finalHeader as Map<String, String>?)
            .timeout(Duration(seconds: _timeOut));
      else if (_method == ApiConnectionMethod.POST) {
        if (listFile != null) {
          var request = http.MultipartRequest("POST", uri);
          request.headers.addAll(finalHeader as Map<String, String>);
          if (bodyParam != null && bodyParam!.length > 0) {
            bodyParam!.forEach((key, value) {
              try {
                Map<String, dynamic>? map = value;
                request.fields[key] = json.encode(map);
              } catch (_) {
                request.fields[key] = value.toString();
              }
            });
          }

          for (MultipartFileModel model in listFile!) {
            if (model.file != null) {
              String name = basename(model.file!.path);
              request.files.add(await http.MultipartFile.fromPath(
                  model.name ?? name, model.file!.path,
                  contentType: MediaType.parse(_typeMultipart),
                  filename: name));
            }
          }

          customPrint("$_tag Param: ${request.fields}");
          request.files.forEach((model) {
            customPrint("$_tag File: ${model.field} - ${model.filename}");
          });

          var result =
          await request.send().timeout(new Duration(seconds: _timeOut));
          response = await http.Response.fromStream(result);
        } else {
          dynamic body = _isJson ? json.encode(bodyParam) : bodyParam;
          customPrint("$_tag Param: $body");
          response = await Global.client
              .post(uri, headers: finalHeader as Map<String, String>?, body: body)
              .timeout(Duration(seconds: _timeOut));
        }
      } else
        response =
        await http.get(uri).timeout(Duration(seconds: _timeOut));
    } on TimeoutException catch (error) {
      response = getError(AppLocalizations.text(LangKey.timeout_error));
      return await handleError(response);
    } on SocketException catch (error) {
      response = getError("${AppLocalizations.text(LangKey.server_error)}\n${error.message}");
      return await handleError(response);
    } on ArgumentError catch (error) {
      response = getError("${AppLocalizations.text(LangKey.server_error)}\n${error.message}");
      return await handleError(response);
    } catch (error) {
      response = getError("${AppLocalizations.text(LangKey.server_error)}\n${error.toString()}");
      return await handleError(response);
    }

    return await handleResponse(response);
  }

  T getError(String? error, {int? errorCode});

  Future<T> handleError(T model);

  Future<T> handleResponse(http.Response? response);
}

enum ApiConnectionMethod { GET, POST, GOOGLE }

