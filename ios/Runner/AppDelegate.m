#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <openinstall_flutter_plugin/OpeninstallFlutterPlugin.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

static NSString *const channel_invoke_meiqia = @"com.akuhome.recook/goToNativePage";

static NSString *const method_init = @"initSDK";
static NSString *const method_start_chat = @"startChat";


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    [AMapServices sharedServices].apiKey = @"e8a8057cfedcdcadcf4e8f2c7f8de982";
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void)intiNav{
    FlutterViewController *flutterVc = (FlutterViewController *)self.window.rootViewController;
    self.navigation = [[UINavigationController alloc] initWithRootViewController:flutterVc];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigation;
    [self.navigation setNavigationBarHidden:YES animated:YES];
    [self.window makeKeyWindow];
    
    
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:channel_invoke_meiqia binaryMessenger:flutterVc];
    
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        
    }];
}

-(void)initChannel {
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //判断是否通过OpenInstall URL Scheme 唤起App
    if([OpeninstallFlutterPlugin handLinkURL:url]){//必写
        return YES;
    }
    
    return [super application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //判断是否通过OpenInstall URL Scheme 唤起App
    if  ([OpeninstallFlutterPlugin handLinkURL:url]){//必写
        return YES;
    }
    return [super application:application openURL:url options:options];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler
{
    //判断是否通过OpenInstall Universal Link 唤起App
    if ([OpeninstallFlutterPlugin continueUserActivity:userActivity]){//如果使用了Universal link ，此方法必写
        return YES;
    }
    //其他第三方回调；
    return [super application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

@end
