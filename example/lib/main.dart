import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_current_locale/current_locale.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
{
  CurrentLocale locale = CurrentLocale();
  String _currentLocale = 'Unknown';
  String _currentCountryCode = "Uknown";

  @override
  void initState()
  {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async
  {
    String currentLocale;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try
    {
      currentLocale = await locale.getCurrentLocale();
    }
    on PlatformException {
      currentLocale = 'Failed to get locale.';
    }

    String currentCountryCode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try
    {
      currentCountryCode = await locale.getCurrentCountryCode();
    }
    on PlatformException {
      currentCountryCode = 'Failed to get country code.';
    }


    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _currentLocale = currentLocale;
      _currentCountryCode = currentCountryCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Locale Info'),
        ),
        body: Center(
          child: Column(mainAxisSize:MainAxisSize.min,children:[
            Text('Current Language: $_currentLocale\n'),
            Text('Current Country Code: $_currentCountryCode\n')
          ]),
        ),
      ),
    );
  }
}
