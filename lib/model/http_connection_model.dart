import 'package:flutter/material.dart';

class HttpConnectionModel {
   String? domain = '';
   String? brandCode = '';
   String? accessToken = '';
   Locale? locale ;

    HttpConnectionModel({this.domain, this.brandCode, this.accessToken, this.locale });
}
