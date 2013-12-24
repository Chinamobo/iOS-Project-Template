
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
    
    // TODO: 如有可能，需要把模块初始化置后
    [DataStack sharedInstance];
    [API sharedInstance];
    
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
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
