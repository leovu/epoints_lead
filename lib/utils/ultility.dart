
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';

void keyboardDismissOnTap(BuildContext context) {
  final currentFocus = FocusScope.of(context);
  FocusScopeNode rootScope = WidgetsBinding.instance.focusManager.rootScope;

  if (currentFocus != rootScope) {
    if (currentFocus.hasFocus && !currentFocus.hasPrimaryFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

customPrint(dynamic event) {
  log(event.toString());
  
}
 double getWidthOfItemPerRow(BuildContext context, int itemPerRow,
      {double? padding, double? separate}) {
    return (AppSizes.maxWidth! -
            (padding ?? AppSizes.maxPadding) * 2 -
            ((itemPerRow - 1) * (separate ?? AppSizes.minPadding)) -
            1) /
        itemPerRow;
  }

dynamic stringToJson(String? event) {
  if (event == null) return null;
  return json.decode(event);
}

String parseAddress(CustomerCreateAddressModel? model) {
  if (model == null) {
    return "";
  }
  List<String> events = [
    if (model.street != null) model.street!,
    if (model.wardModel != null) model.wardModel!.name ?? "",
    if (model.districtModel != null) model.districtModel!.name ?? "",
    if (model.provinceModel != null) model.provinceModel!.name ?? "",
  ];

  return events.join(", ");
}


fieldFocus(BuildContext context, FocusNode? focusNode) {
  FocusScope.of(context).requestFocus(focusNode);
}

class Validators {
  var validatePhone = RegExp(r"^[+#*()\[\]]*([0-9][ ext+-pw#*()\[\]]*){10,45}$");
  var validateNumber = RegExp(r"^[\d]*$");

 bool isValidPhone(String phone){
    if (phone!=null&&phone.isNotEmpty&&validatePhone.hasMatch(phone)){
      return true;
    }
    return false;
  }

  bool isNumber(String number){
    if (number!=null&&number.isNotEmpty&&validateNumber.hasMatch(number)){
      return true;
    }
    return false;
  }


}

extension IterableModifier<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) =>
      cast<E>().firstWhere((v) => v != null && test(v));
}
