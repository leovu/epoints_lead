import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';

class CustomPermissionRequest {
  static Future<bool> request(BuildContext context, PermissionRequestType type) async {
    return PermissionRequest.request(type, (){
      assert (context != null);
      String permission;
      if(type == PermissionRequestType.CAMERA){
        permission = AppLocalizations.text(LangKey.camera);
      }
      else if(type == PermissionRequestType.LOCATION){
        permission = AppLocalizations.text(LangKey.location);
      }
      else if(type == PermissionRequestType.STORAGE){
        permission = AppLocalizations.text(LangKey.storage);
      }
      else if(type == PermissionRequestType.NOTIFICATION){
        permission = AppLocalizations.text(LangKey.notification);
      }
      return LeadConnection.showMyDialogWithFunction(
          context,
          // "${AppLocalizations.text(LangKey.request_permissions)} $permission",
          "${AppLocalizations.text(LangKey.message_permission)} $permission",
          // enableCancel: true,
          // textSubmitted: AppLocalizations.text(LangKey.allow),
          ontap: (){
            Navigator.pop(context);
            PermissionRequest.openSetting();
          }
      );
    });
  }

  static Future<bool> check(PermissionRequestType type) => PermissionRequest.check(type);
}

enum PermissionRequestType{
  CAMERA, LOCATION, STORAGE, NOTIFICATION, MICROPHONE
}

class PermissionRequest {
  static openSetting() {
    MethodChannel("flutter.permission/requestPermission").invokeMethod('open_screen');
  }

  static Future<bool> request(PermissionRequestType type, Function onDontAskAgain) async {
    final channel = MethodChannel("flutter.permission/requestPermission");
    bool event = false;
    int result = 0;

    try{
      if(type == PermissionRequestType.CAMERA){
        result = await channel.invokeMethod<int>('camera',{'isRequest':true});
      }
      else if(type == PermissionRequestType.LOCATION){
        result = await channel.invokeMethod<int>('location',{'isRequest':true});
      }
      else if(type == PermissionRequestType.STORAGE){
        result = await channel.invokeMethod<int>('storage',{'isRequest':true});
      }
      else if(type == PermissionRequestType.NOTIFICATION){
        result = await channel.invokeMethod<int>('notification',{'isRequest':true});
      }
      else if(type == PermissionRequestType.MICROPHONE){
        result = await channel.invokeMethod<int>('microphone',{'isRequest':true});
      }
    }
    catch(_){}

    if(result == -1)
      onDontAskAgain();
    else if(result == 1)
      event = true;

    return event;
  }

  static Future<bool> check(PermissionRequestType type) async {
    final channel = MethodChannel("flutter.permission/checkPermission");
    int result = 0;
    try{
      if(type == PermissionRequestType.CAMERA){
        result = await channel.invokeMethod<int>('camera',{'isRequest':false});
      }
      else if(type == PermissionRequestType.LOCATION){
        result = await channel.invokeMethod<int>('location',{'isRequest':false});
      }
      else if(type == PermissionRequestType.STORAGE){
        result = await channel.invokeMethod<int>('storage',{'isRequest':false});
      }
      else if(type == PermissionRequestType.NOTIFICATION){
        result = await channel.invokeMethod<int>('notification',{'isRequest':false});
      }
      else if(type == PermissionRequestType.MICROPHONE){
        result = await channel.invokeMethod<int>('microphone',{'isRequest':false});
      }
    }
    catch(_){}

    return result == 1?true:false;
  }
}
