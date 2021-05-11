import 'dart:async';

import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter_current_locale/current_locale.dart';

class CurrentLocaleFactory
{
  static CurrentLocaleManager createManager() => CurrentLocaleWeb();
}

class CurrentLocaleWeb extends CurrentLocaleManager
{
  bool get isPlatformSupported
  {
    return kIsWeb;
  }

  Future<String> getCurrentLanguage() async
  {
    var language = html.window.navigator.language;
    if(language == null) return "nb";
    switch(language)
    {
      case "nb-NO":
      case "nb":
      case "no":
      case "nn": return "nb";
      case "en-US":
      case "en": return "en";
    }
    return "nb";
  }

  Future<String> getCurrentCountryCode() async
  {
    var language = html.window.navigator.language;
    if(language == null) return "NO";
    switch(language)
    {
      case "nb-NO":
      case "nb":
      case "no":
      case "nn": return "NO";
      case "en-US":
      case "en": return "US";
    }
    return "NO";
  }

  CurrentLocaleResult get _noCurrentLocalResult
  {
    return CurrentLocaleResult(
        identifier: "nb_NO",
        decimals: ",",
        language: CurrentLocaleInfo(phone: "nb",locale: "no"),
        country: CurrentCountryInfo(phone: null, locale: "NO", region: "NO")
    );
  }

  CurrentLocaleResult get _enCurrentLocaleResult
  {
    return CurrentLocaleResult(
        identifier: "en_US",
        decimals: ",",
        language: CurrentLocaleInfo(phone: "en",locale: "en"),
        country: CurrentCountryInfo(phone: null, locale: "US", region: "US")
    );
  }

  Future<CurrentLocaleResult> getCurrentLocale() async
  {
    var language = html.window.navigator.language;
    if(language == null) return Future.value(_noCurrentLocalResult);
    switch(language)
    {
      case "nb-NO":
      case "nb":
      case "no":
      case "nn": return Future.value(_noCurrentLocalResult);
      case "en-US":
      case "en": return Future.value(_enCurrentLocaleResult);
    }
    return Future.value(_noCurrentLocalResult);
  }
}
