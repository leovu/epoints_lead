
import 'package:flutter/material.dart';

void keyboardDismissOnTap(BuildContext context) {
  final currentFocus = FocusScope.of(context);
  FocusScopeNode rootScope = WidgetsBinding.instance.focusManager.rootScope;

  if (currentFocus != rootScope) {
    if (currentFocus.hasFocus && !currentFocus.hasPrimaryFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
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
