#import "LocalStoragePlugin.h"
#if __has_include(<local_storage/local_storage-Swift.h>)
#import <local_storage/local_storage-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "local_storage-Swift.h"
#endif

@implementation LocalStoragePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLocalStoragePlugin registerWithRegistrar:registrar];
}
@end
