import Flutter
import UIKit
import CoreTelephony

public class SwiftFlutterCurrentLocalePlugin: NSObject, FlutterPlugin
{
    static let kChannelName = "plugins.olavstoppen.no/current_locale"

    func getCurrentLanguage() -> String
    {
        let fallback = Locale.current.languageCode ?? "en"
        guard let preferred = Locale.preferredLanguages.first else { return fallback }
        return Locale(identifier:preferred).languageCode ?? fallback
    }

    func getCurrentCountryCode() -> String
    {
        let fallback = ""
        guard let carrier = CTTelephonyNetworkInfo().subscriberCellularProvider else { return fallback }
        guard let countryCode = carrier.isoCountryCode else { return "" }
        return countryCode
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
        case "getCurrentLanguage": result(getCurrentLanguage())
        case "getCurrentCountryCode": result(getCurrentCountryCode())
        default: result(FlutterMethodNotImplemented)
        }
    }
}
