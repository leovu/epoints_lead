import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CustomDocumentPicker {
  static Future<File?> openDocument(
      BuildContext context, {
        List<String>? params,
      }) async {
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
    FilePickerResult? files = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: params,
        allowMultiple: true
    );

    return files == null ? null : files.files.map((e) => File(e.path!)).toList();
  }
}
