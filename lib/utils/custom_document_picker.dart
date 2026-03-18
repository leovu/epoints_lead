import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/utils/custom_permission_request.dart';

class CustomDocumentPicker {
  static Future<File?> openDocument(
      BuildContext context, {
        List<String>? params,
      }) async {
    try {
      if (Platform.isAndroid) {
        bool permission = false;
        permission = await CustomPermissionRequest.request(
            context, PermissionRequestType.STORAGE);

        if (!permission) return null;
      }
    } catch (_) {
      return null;
    }

    FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: params,
    );

    return file == null ? null : File(file.files.single.path!);
  }

  static Future<List<File>?> openMultiDocument(
      BuildContext context, {
        List<String>? params,
      }) async {
    try {
      bool permission = false;
      permission = await CustomPermissionRequest.request(
          context, PermissionRequestType.STORAGE);

      if (!permission) return null;
    } catch (_) {
      return null;
    }

    FilePickerResult? files = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: params,
        allowMultiple: true
    );

    return files == null ? null : files.files.map((e) => File(e.path!)).toList();
  }
}