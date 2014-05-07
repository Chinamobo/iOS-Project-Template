
#import "AppDelegate.h"
#import "debug.h"
#import "DataStack.h"
#import "API.h"
#import "UncaughtExceptionHandler.h"
#import "MBNavigationBarAppearanceConfigurator.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (DebugEnableUncaughtExceptionHandler) {
        InstallUncaughtExceptionHandler();
    }

    // 通用模块设置，按需取消注释以启用
    // 如有可能，需要把模块初始化置后
//    [API sharedInstance];

    // Core Data
//    [DataStack sharedInstance];

    // 全局点击空白隐藏键盘
//    [RFKeyboard setEnableAutoDisimssKeyboardWhenTouch:YES];

    [self generalAppearanceSetup];
    return YES;
}

- (void)generalAppearanceSetup {
    MBNavigationBarAppearanceConfigurator *nac = [MBNavigationBarAppearanceConfigurator new];
    nac.backgroundImage = [[UIImage imageNamed:RF_iOS7Before? @"NavigationBarBackgroundOld" : @"NavigationBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];

    // 在 iOS 6 上模拟 iOS 7 外观
    nac.style = MBNavigationBarAppearanceStyle_iOS7;
    [nac applay];
}

@end
