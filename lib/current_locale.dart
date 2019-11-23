import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CurrentLocale
{
  static const String kChannelName = "plugins.olavstoppen.no/current_locale";

  bool get isPlatformSupported => Platform.isIOS || Platform.isAndroid;

  Future<String> getCurrentLanguage() async
  {
    return _invokeMethod("getCurrentLanguage");
  }

  Future<String> getCurrentCountryCode() async
  {
    return _invokeMethod("getCurrentCountryCode");
  }

  Future<CurrentLocaleResult> getCurrentLocale() async
  {
    var supported = isPlatformSupported;
    if (!supported)
      return Future.value(null);

    var platform = MethodChannel(kChannelName);
    try
    {
      dynamic result = await platform.invokeMethod("getCurrentLocale");
      if (result != null && result is Map)
      {
        CurrentLocaleInfo getInfo(String key)
        {
          final fallback = CurrentLocaleInfo();
          if (!result.containsKey(key)) return fallback;
          try{
            var d = Map<String, String>.from(result[key]);
            String phone;
            String locale;
            if (d.containsKey("phone"))
              phone = d["phone"];
            if (d.containsKey("locale"))
              locale = d["locale"];
            return CurrentLocaleInfo(phone: phone, locale: locale);
          } catch (e)
          {
            return fallback;
          }

        }
        var country = getInfo("country");
        var language = getInfo("language");
        return Future.value(CurrentLocaleResult(language:language,country:country));
      }
    }
    catch (e)
    {

    }
    return Future.value(null);
  }

  Future<String> _invokeMethod(String method) async
  {
    var supported = isPlatformSupported;
    if (!supported)
      return Future.value(null);

    var platform = MethodChannel(kChannelName);
    try
    {
      String result = await platform.invokeMethod(method);
      if (result != null)
      {
        return Future.value(result);
      }
    }
    catch (e)
    {

    }
    return Future.value(null);
  }
}

class CurrentLocaleResult
{
  final CurrentLocaleInfo language;
  final CurrentLocaleInfo country;

  CurrentLocaleResult({@required this.language,@required this.country});
}

class CurrentLocaleInfo
{
  final String phone;
  final String locale;

  CurrentLocaleInfo({this.phone,this.locale});
}
