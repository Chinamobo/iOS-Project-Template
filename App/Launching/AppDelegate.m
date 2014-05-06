
//
//  AppDelegate.m
//  App
//
//  Created by BB9z on 13-9-22.
//  Copyright (c) 2013年 Chinamobo. All rights reserved.
//

#import "AppDelegate.h"
#import "debug.h"
#import "DataStack.h"
#import "API.h"
#import "UncaughtExceptionHandler.h"

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
    // Checkbox
    //    id checkboxAppearance = [RFCheckBox appearance];
    //    id checkboxAppearance2 = [RFCheckBox appearanceWhenContainedIn:[LoginViewController class], nil];
    //    [checkboxAppearance setOnImage:[UIImage imageNamed:@"checkbox_on"]];
    //    [checkboxAppearance2 setOnHighlightedImage:[UIImage imageNamed:@"checkbox_onHighlighted"]];
    //    [checkboxAppearance setOnDisabledImage:[UIImage imageNamed:@"checkbox_onDisabled"]];
    //    [checkboxAppearance setOffImage:[UIImage imageNamed:@"checkbox_off"]];
    //    [checkboxAppearance2 setOffHighlightedImage:[UIImage imageNamed:@"checkbox_offHighlighted"]];
    //    [checkboxAppearance setOffDisabledImage:[UIImage imageNamed:@"checkbox_offDisabled"]];
    
    // 刷新按钮
    //    [[UIActivityIndicatorView appearanceWhenContainedIn:[RFRefreshButton class], nil] setColor:[UIColor colorWithRGBHex:0x2384d0]];
}

@end
