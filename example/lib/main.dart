import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_current_locale/current_locale.dart';
import 'package:intl/intl.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with PriceFormatter
{
  CurrentLocale locale = CurrentLocale();
  String currentLocale = "Unknown";
  String _currentLanguage = 'Unknown';
  String _currentCountryCode = "Unknown";
  String _currentRegion = "Unknown";
  String decimalSeparator = "Unknown";

  bool loading = true;
  double currentPrice = 2.01;

  @override
  void initState()
  {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async
  {
    String currentLanguage;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try
    {
      currentLanguage = await locale.getCurrentLanguage();
    }
    on PlatformException {
      currentLanguage = 'Failed to get language.';
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

    CurrentLocaleResult currentLocaleResult;

    try
    {
      currentLocaleResult = await locale.getCurrentLocale();
      _currentRegion = currentLocaleResult?.country?.region ?? _currentRegion;
      currentLocale = currentLocaleResult?.identifier ?? currentLocale;
      decimalSeparator = currentLocaleResult?.decimals ?? decimalSeparator;
    }
    on PlatformException {
    }


    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {      
      _currentLanguage = currentLanguage;
      _currentCountryCode = currentCountryCode;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Locale Info'),
        ),
        body: loading ? SizedBox() : Center(
          child: Column(mainAxisSize:MainAxisSize.min,children:[
            Text('Current Locale: $currentLocale\n'),
            Text('Current Language: $_currentLanguage\n'),
            Text('Current Country Code: $_currentCountryCode\n'),
            Text('Current Decimal Separator: $decimalSeparator\n'),
            Text('Current Region: $_currentRegion\n'),
            TextFormField(                            
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged:changedPrice,              
              initialValue: formatPrice(currentPrice),
            ),
            Text(formatPrice(currentPrice))
          ]),
        ),
      ),
    );
  }

  void changedPrice(String value)
  {
    setState((){
      currentPrice = parsePrice(value);
    });
  }
}

mixin PriceFormatter
{
	String currentLocale;
  String decimalSeparator;

  MoneyFormatterSettings get priceSettings => MoneyFormatterSettings(
        symbol: '',
        thousandSeparator: '',
        decimalSeparator: decimalSeparator,
        symbolAndNumberSeparator: '',
        fractionDigits: 2,        
    );

	NumberFormat get priceFormatter => NumberFormat.compactCurrency(locale:currentLocale,symbol:"");

	String formatPrice(double price)
	{
		if (price == null) return null;
    var settings = priceSettings;
    var formatter = FlutterMoneyFormatter(amount:price,settings:settings);
    return formatter.output.nonSymbol;
		// var formatter = priceFormatter;
		// return formatter.format(price);		
	}

	double parsePrice(String value)
	{
    //DecimalFormat myFormatter = DecimalFormat("###$decimalSeparator###");
    // TODO: Figure out how to not rely on locale to parse a double, want to just use decimalSeparator, since locale is unreliable
    // You can test this in action, if u have an iphone with english language, and norway region, and a phone with norwegian language and US as a region
		var formatter = priceFormatter;
		try
		{
			var val = formatter.parse(value);
			if (val != null)
				return val;
		}
		catch (ex)
		{
			print("Invalid price format - $ex");
		}
		return double.tryParse(value) ?? null;
	}
}