import 'dart:async';
import 'dart:io';
import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/connection/network_connectivity.dart';
import 'package:lead_plugin_epoint/model/response_model.dart';
import 'package:path/path.dart';

abstract class AWSConnection<T> {
  late AWSFileModel file;
  String get secretKey;
  String get region;
  String get accessKey;
  String get bucket;

  Future<T> upload() async {
    T? data = await _checkConnectivity();
    if (data != null) {
      return await handleError(data);
    }
    final destDir = "directory";
    final filename = basename(file.file!.path);
    final code = await AwsS3.uploadFile(
        accessKey: accessKey,
        secretKey: secretKey,
        file: file.file!,
        bucket: bucket,
        region: region,
        destDir: destDir,
        filename: filename);

    if (code != "200" && code != "204") {
      return await handleError(getError(
        AppLocalizations.text(LangKey.server_error),
      ));
    }

    return await handleResponse(ResponseModel(
        url: "https://$bucket.s3.$region.amazonaws.com/$destDir/$filename",
        success: true));
  }

  Future<T?> _checkConnectivity() async {
    if (!(await NetworkConnectivity.isConnected())) {
      return getError(AppLocalizations.text(LangKey.connection_error));
    }
    return null;
  }

  T getError(String? error, {int? errorCode});

  Future<T> handleError(T model);

  Future<T> handleResponse(ResponseModel response);
}

class AWSFileModel {
  String? fileName;
  File? file;
  AWSFileModel({this.fileName, this.file});
}

class AWSInteraction extends AWSConnection<ResponseModel> {
  final BuildContext? context;
  final bool showError;

  AWSInteraction({
    this.context,
    required AWSFileModel file,
    this.showError = true,
  }) {
    this.file = file;
  }

  @override
  String get accessKey => "AKIAUO66DKWUKVBVJCJK";

  @override
  String get bucket => "epoint-bucket";

  @override
  String get region => "ap-southeast-1";

  @override
  String get secretKey => "tVfiARnRpHC51C/4O1OrZg3dNsTOVP0Fntf2MHAq";

  @override
  ResponseModel getError(String? error, {int? errorCode}) {
    return ResponseModel(errorDescription: error, errorCode: errorCode);
  }

  @override
  Future<ResponseModel> handleError(ResponseModel model) async {
    if (showError && context != null) {
      await LeadConnection.showMyDialog(
          context!, model.errorDescription ?? "");
    }
    return model;
  }

  @override
  Future<ResponseModel> handleResponse(ResponseModel response) async {
    return response;
  }
}
