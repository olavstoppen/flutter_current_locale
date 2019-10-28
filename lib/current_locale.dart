import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class CurrentLocale
{
  static const String kChannelName = "plugins.olavstoppen.no/current_locale";

  Future<String> getCurrentLocale() async
  {
    if (Platform.isIOS || Platform.isAndroid)
    {
      var platform = MethodChannel(kChannelName);
      try
      {
        String result = await platform.invokeMethod('getCurrentLanguage');
        if (result != null)
        {
          return Future.value(result);
        }
      }
      on PlatformException catch (e)
      {

      }
    }
    return Future.value(null);
  }
}