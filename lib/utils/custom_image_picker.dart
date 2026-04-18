
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/widget/custom_bottom_option.dart';
import 'package:lead_plugin_epoint/widget/custom_bottom_sheet.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';

class CustomImagePicker {
  static showPicker(BuildContext context, Function(File) onConfirm, {bool isSelfie = false}){
    CustomNavigator.showCustomBottomDialog(context, CustomBottomSheet(
        body: CustomBottomOption(
          options: [
            CustomBottomOptionModel(
                text: AppLocalizations.text(LangKey.capture),
                onTap: () async {
                  File? file = await pickImage(context, ImageSource.camera, isSelfie: isSelfie);
                  if(file != null){
                    Navigator.of(context).pop();
                    onConfirm(file);
                  }
                }
            ),
            CustomBottomOptionModel(
                text: AppLocalizations.text(LangKey.select_from_gallery),
                onTap: () async {
                  File? file = await pickImage(context, ImageSource.gallery);
                  if(file != null){
                    Navigator.of(context).pop();
                    onConfirm(file);
                  }
                }
            )
          ],
        )
    ));
  }

  static showMultiPicker(BuildContext context, Function(List<File>) onConfirm, {bool isSelfie = false}){
    CustomNavigator.showCustomBottomDialog(context, CustomBottomSheet(
        body: CustomBottomOption(
          options: [
            CustomBottomOptionModel(
                text: AppLocalizations.text(LangKey.capture),
                onTap: () async {
                  File? file = await pickImage(context, ImageSource.camera, isSelfie: isSelfie);
                  if(file != null){
                    onConfirm([file]);
                  }
                }
            ),
            CustomBottomOptionModel(
                text: AppLocalizations.text(LangKey.select_from_gallery),
                onTap: () async {
                  List<File>? files = await pickMultiImage(context);
                  if(files != null){
                    onConfirm(files);
                  }
                }
            )
          ],
        )
    ));
  }

  static Future<File?> pickImage(BuildContext? context, ImageSource? source,
      {bool isSelfie = false}) async {
    if (source == null) return null;
    // Bỏ qua CustomPermissionRequest (channel native chưa được hook up).
    // image_picker tự handle:
    //  - Gallery: Photo Picker (Android 13+) không cần permission.
    //  - Camera: ACTION_IMAGE_CAPTURE intent — hệ thống tự xin quyền nếu cần.
    try {
      final pickedFile = await ImagePicker().pickImage(
          source: source,
          preferredCameraDevice:
              isSelfie ? CameraDevice.front : CameraDevice.rear,
          maxWidth: 1536);
      if (pickedFile == null) return null;
      return File(pickedFile.path);
    } catch (_) {
      return null;
    }
  }

  static Future<List<File>?> pickMultiImage(BuildContext context) async {
    // Bỏ check STORAGE — Photo Picker (Android 13+) không cần quyền,
    // image_picker tự xử lý cho các phiên bản cũ hơn.
    try {
      List<XFile> pickedFile = await ImagePicker().pickMultiImage();
      return pickedFile.map((e) => File(e.path)).toList();
    } catch (_) {
      return null;
    }
  }
}
