#import "LeadPluginEpointPlugin.h"
#if __has_include(<lead_plugin_epoint/lead_plugin_epoint-Swift.h>)
#import <lead_plugin_epoint/lead_plugin_epoint-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "lead_plugin_epoint-Swift.h"
#endif

@implementation LeadPluginEpointPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLeadPluginEpointPlugin registerWithRegistrar:registrar];
}
@end
