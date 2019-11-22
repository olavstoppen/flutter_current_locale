import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class CurrentLocale
{
  static const String kChannelName = "plugins.olavstoppen.no/current_locale";

  Future<String> getCurrentLocale() async
  {
    return _invokeMethod("getCurrentLanguage");
  }

  Future<String> getCurrentCountryCode() async
  {
    return _invokeMethod("getCurrentCountryCode");
  }

  Future<String> _invokeMethod(String method) async
  {
    var supported = Platform.isIOS || Platform.isAndroid;
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
    on PlatformException catch (e)
    {

    }
    return Future.value(null);
  }
}