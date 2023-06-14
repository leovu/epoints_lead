import 'dart:async';
import 'dart:io';
import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:http/http.dart' as http;
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/connection/network_connectivity.dart';
import 'package:mime/mime.dart';

abstract class AWSConnection<T>{

  late AWSFileModel file;
  String get secretKey;
  String get region;
  String get accessKey;
  String get bucket;
  String get domain;

  Future<T> upload() async {
    T? data = await _checkConnectivity();
    if (data != null) {
      return await handleError(data);
    }

    final mimeType = lookupMimeType(file.file!.path)!;

    final url = await AwsS3.uploadFile(
        accessKey: accessKey,
        secretKey: secretKey,
        file: file.file!,
        bucket: bucket,
        region: region,
        contentType: mimeType
    );

    if((url ?? "").isEmpty){
      return await handleError(getError(
        AppLocalizations.text(LangKey.server_error),
      ));
    }

    return await handleResponse(http.Response(url!, 200));
  }

  Future<T?> _checkConnectivity() async {
    if (!(await NetworkConnectivity.isConnected())) {
      return getError("Lỗi");
    }
    return null;
  }

  T getError(String? error, {int? errorCode});

  Future<T> handleError(T model);

  Future<T> handleResponse(http.Response response);
}

class AWSFileModel {
  String? fileName;
  File? file;
  AWSFileModel({
    this.fileName,
    this.file
  });
}