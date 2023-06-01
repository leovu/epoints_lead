

import 'package:flutter/services.dart';

class MaximumNumberInputFormatter extends TextInputFormatter {

  final int maxNumber;

  MaximumNumberInputFormatter(this.maxNumber);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    if(newValue.text.isNotEmpty){
      int number = int.tryParse(newValue.text);
      if(number > maxNumber){
        return TextEditingValue(
            text: maxNumber.toString(),
            selection: TextSelection.collapsed(offset: maxNumber.toString().length)
        );
      }
      return newValue;
    }

    return newValue;
  }
}