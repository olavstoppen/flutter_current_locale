import Flutter
import UIKit
import CoreTelephony

public class SwiftFlutterCurrentLocalePlugin: NSObject, FlutterPlugin
{
    static let kChannelName = "plugins.olavstoppen.no/current_locale"

    func getCurrentLanguage() -> String?
    {
        guard let preferred = Locale.preferredLanguages.first else { return nil }
        return Locale(identifier:preferred).languageCode
    }

    func getCurrentCountryCode() -> String?
    {
        guard let carrier = CTTelephonyNetworkInfo().subscriberCellularProvider else { return nil }
        guard let countryCode = carrier.isoCountryCode else { return nil }
        return countryCode
    }
    
    func fallbackRegion() -> String?
    {
        let fallback = Locale.current.regionCode
        guard let preferred = Locale.preferredLanguages.first else { return fallback }
        return Locale(identifier:preferred).regionCode ?? fallback
    }

    func fallbackLanguage() -> String?
    {
        return Locale.current.languageCode
    }
    
    func getCurrentLocale() -> [String:Any]
    {
        var d = [String:Any]()
        
        var language = [String:Any]()
        language["phone"] = getCurrentLanguage()
        language["locale"] = fallbackLanguage()
        d["language"] = language
        
        var country = [String:Any]()
        country["phone"] = getCurrentCountryCode()
        country["locale"] = fallbackRegion()
        d["country"] = country
        
        return d
    }
    
    public static func register(with registrar: FlutterPluginRegistrar)
    {
        let channel = FlutterMethodChannel(name:kChannelName, binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterCurrentLocalePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        switch call.method
        {
        case "getCurrentLanguage": result(getCurrentLanguage() ?? fallbackLanguage())
        case "getCurrentCountryCode": result(getCurrentCountryCode() ?? fallbackRegion())
        case "getCurrentLocale": result(getCurrentLocale())
        default: result(FlutterMethodNotImplemented)
        }
    }
}
