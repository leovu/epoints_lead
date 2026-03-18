import 'package:flutter/widgets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/connection/http/http_status_code.dart';
import 'package:lead_plugin_epoint/connection/http_connection.dart';
import 'package:lead_plugin_epoint/model/response_model.dart';
import 'package:lead_plugin_epoint/presentation/network/api.dart';
import 'package:lead_plugin_epoint/presentation/network/http_connection.dart';
import 'package:lead_plugin_epoint/utils/global.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:http/http.dart' as http;

class Interaction extends HttpConnection<ResponseModel> {

  final String _tag = "Interaction";

  final BuildContext? context;
  final String url;
  final Map<String, dynamic>? param;
  final Map<String, String>? header;
  final List<MultipartFileModel>? files;
  final bool showError;
  final bool isPublic;
  final bool isShowBrandCode;
  final bool isEmptyHeader;

  Interaction({
    this.context,
    required this.url,
    this.param,
    this.header,
    this.files,
    this.showError = true,
    this.isPublic = false,
    this.isShowBrandCode = true,
    this.isEmptyHeader = false
  });

  @override
  // TODO: implement apiUrl
  String get apiUrl => url;

  @override
  // TODO: implement bodyParam
  Map<String, dynamic>? get bodyParam => param;

  @override
  // TODO: implement headerParam
  Map<String, String>? get headerParam => header;

  @override
  // TODO: implement listFile
  List<MultipartFileModel>? get listFile => files;

  @override
  // TODO: implement baseUrl
  String? get baseUrl =>  API.server;

  @override
  // TODO: implement tokenKey
  String get tokenKey => Global.asscessToken;

  @override
  // TODO: implement showBrandCode
  bool get showBrandCode => isShowBrandCode;

  @override
  // TODO: implement isEmptyHeader
  bool get emptyHeader => isEmptyHeader;

@override
  Future<ResponseModel> handleError(ResponseModel model) async {
    if (showError)
        await CustomNavigator.showCustomAlertDialog(context!,
            AppLocalizations.text(LangKey.notification), model.errorDescription ?? "");
    return model;
  }

  @override
  Future<ResponseModel> handleResponse(http.Response? response) async {
    // TODO: implement handleResponse
    customPrint("$_tag Http url: $url");
    customPrint("$_tag Http code: ${response!.statusCode}");
    customPrint("$_tag Http body: ${response.body}");
    if (HttpStatusCode.success.contains(response.statusCode)) {
      if (response.body == "") {
        return await handleError(getError(AppLocalizations.text(LangKey.server_error)));
      } else {
        try {
          ResponseModel modelResponse =
          ResponseModel.fromJson(stringToJson(response.body));
          if (modelResponse.success!)
            return modelResponse;
          else
          return await handleError(modelResponse);
        } catch (_) {
          return await handleError(getError(AppLocalizations.text(LangKey.data_error)));
        }
      }
    } else {
      return await handleError(getError(
          AppLocalizations.text(LangKey.server_error),
          errorCode: response.statusCode));
    }
  }

  @override
  ResponseModel getError(String? error, {int? errorCode}) {
    // TODO: implement getError
    return ResponseModel(errorDescription: error, errorCode: errorCode);
  }
}