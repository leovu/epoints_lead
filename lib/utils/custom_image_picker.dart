
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/utils/custom_permission_request.dart';
import 'package:lead_plugin_epoint/widget/custom_bottom_option.dart';
import 'package:lead_plugin_epoint/widget/custom_bottom_sheet.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:image/image.dart' as img;

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
    try {
      bool permission = false;
      if (source == ImageSource.camera) {
        permission = await CustomPermissionRequest.request(
            context!, PermissionRequestType.CAMERA);
      } else {
        permission = await CustomPermissionRequest.request(
            context!, PermissionRequestType.STORAGE);
      }
      if (!permission) return null;
    } catch (_) {
      return null;
    }

    final pickedFile = await ImagePicker().pickImage(
        source: source,
        preferredCameraDevice:
            isSelfie ? CameraDevice.front : CameraDevice.rear,
        maxWidth: 1536);

    if (pickedFile == null) return null;

    return File(pickedFile.path);
  }
  
  static Future<File> _orientationImage(BuildContext context, XFile file) async {

    return File(file.path);
  }

  static Future<List<File>?> pickMultiImage(BuildContext context) async {
    try {
      bool permission = false;
      permission = await CustomPermissionRequest.request(
          context, PermissionRequestType.STORAGE);
      if (!permission) return null;
    } catch (_) {
      return null;
    }
    List<XFile> pickedFile = await ImagePicker().pickMultiImage();
    if (pickedFile == null)
      return null;
    return pickedFile.map((e) => File(e.path)).toList();
  }
}
