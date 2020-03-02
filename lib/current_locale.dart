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
        String getString(String key)
        {
           String identifier;
            if (result.containsKey(key))
              identifier = result[key];
            return identifier;
        }

        CurrentLocaleInfo getLocale(String key)
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
        CurrentCountryInfo getCountry(String key)
        {
          var info = getLocale(key);
          try
          {
            var d = Map<String, String>.from(result[key]);
            String region;            
            if (d.containsKey("region"))
              region = d["region"];            
            return CurrentCountryInfo(locale:info.locale,phone:info.phone,region:region);
          } 
          catch (e)
          {
            return CurrentCountryInfo(locale:info.locale,phone:info.phone);
          }
        }
        var identifier = getString("identifier");
        var decimals = getString("decimals");
        var country = getCountry("country");
        var language = getLocale("language");
        return Future.value(CurrentLocaleResult(identifier:identifier,decimals:decimals,language:language,country:country));
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
  final String identifier;
  final String decimals;
  final CurrentLocaleInfo language;
  final CurrentCountryInfo country;

  CurrentLocaleResult({@required this.identifier,@required this.decimals,@required this.language,@required this.country});
}

class CurrentLocaleInfo
{
  final String phone;
  final String locale;

  CurrentLocaleInfo({this.phone,this.locale});
}

class CurrentCountryInfo extends CurrentLocaleInfo
{
  final String region;
  
  CurrentCountryInfo({String phone,String locale,this.region}) : super(phone:phone,locale:locale);
}
