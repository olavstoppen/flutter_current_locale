#import "FlutterCurrentLocalePlugin.h"
#import <flutter_current_locale/flutter_current_locale-Swift.h>

@implementation FlutterCurrentLocalePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterCurrentLocalePlugin registerWithRegistrar:registrar];
}
@end
