#import "OnBluetoothPlugin.h"
#if __has_include(<on_bluetooth/on_bluetooth-Swift.h>)
#import <on_bluetooth/on_bluetooth-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "on_bluetooth-Swift.h"
#endif

@implementation OnBluetoothPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOnBluetoothPlugin registerWithRegistrar:registrar];
}
@end
