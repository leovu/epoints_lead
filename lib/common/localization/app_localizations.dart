import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';

class AppLocalizations {
  final Locale? locale;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  static late Map<String, String> _localizedStrings;

  Future<bool> load() async {


    Map<String, dynamic>? jsonMap = await configLanguage(locale!.languageCode);
    if(jsonMap!=null){
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    }
    return true;
  }

  Future<Map<String, dynamic>?> configLanguage(String lang) async {
  var jsonString = await rootBundle.loadString('packages/lead_plugin_epoint/assets/languages/lead_$lang.json', cache: false);
  Map<String, dynamic>? jsonMap = json.decode(jsonString);
  if (jsonMap != null) {
    return jsonMap;
  }
  return null;
}
  static String? text(String key) {
    return _localizedStrings[key];
  }

}

// LocalizationsDelegate is a factory for a set of localized resources
// ignore: lines_longer_than_80_chars
// In this case, the localized strings will be gotten in an AppLocalizations object
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [LangKey.langVi, LangKey.langEn].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    var localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}