import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/connection/aws_connection.dart';
import 'package:lead_plugin_epoint/connection/http/http_status_code.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/response_model.dart';


class AWSInteraction extends AWSConnection<ResponseModel> {

  final BuildContext context;
  final AWSFileModel file;
  final bool showError;

  AWSInteraction({
    this.context,
    @required this.file,
    this.showError = true,
  }):assert(file != null);


  @override
  String get accessKey => "AKIAUO66DKWUKVBVJCJK";

  @override
  String get bucket => "epoint-bucket";

  @override
  String get domain => "https://epoint-bucket.s3";

  @override
  String get region => "ap-southeast-1";

  @override
  String get secretKey => "tVfiARnRpHC51C/4O1OrZg3dNsTOVP0Fntf2MHAq";

  @override
  Future<ResponseModel> handleError(ResponseModel model) async {
    if (showError)
      await LeadConnection.showMyDialog(context, model.errorDescription ?? "");
    return model;
  }

  @override
  Future<ResponseModel> handleResponse(http.Response response) async {
    if (HttpStatusCode.success.contains(response.statusCode)) {
      final modelResponse = ResponseModel(
        url: response.body,
        success: true
      );
      return modelResponse;
    } else {
      return await handleError(getError(
          AppLocalizations.text(LangKey.server_error),
          errorCode: response.statusCode));
    }
  }

  @override
  ResponseModel getError(String error, {int errorCode}) {
    return ResponseModel(errorDescription: error, errorCode: errorCode);
  }
}