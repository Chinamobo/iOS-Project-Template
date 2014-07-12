/*!
    JPushManager
    v 1.1

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import <Foundation/Foundation.h>
#import "APService.h"

/**
 极光推送封装
 
 SDK 下载：http://docs.jpush.cn/display/dev/iOS


 证书生成备忘：
 
 1. 发送证书申请成功后，要下载证书并导入 Keychain 中

 2. 从 Keychain 导出证书要注意选右下角分类的 My Certification，导出格式一定是 p12

 详见官方文档：http://docs.jpush.cn/pages/viewpage.action?pageId=1343727


 使用说明：

 1. 下载 SDK，把 APService.h 和 libPushSDK.a 加入项目，并添加如下框架
 CoreTelephony.framework
 libz.dylib

 2. 修改 PushConfig.plist

 3. 修改 AppDelegate，示例如下：

 @code
#import "JPushManager.h"

@implementation AppDelegate
JPushManagerAppDelegateMethods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [JPushManager setupWithApplicationLaunchOptions:launchOptions];
    return YES;
}

@end
 @endcode

 4. 按需修改实现

 另参考官方集成指南：http://docs.jpush.cn/pages/viewpage.action?pageId=2621727
 
 */
@interface JPushManager : NSObject <RFInitializing>

+ (JPushManager *)setupWithApplicationLaunchOptions:(NSDictionary *)launchOptions;

+ (instancetype)sharedInstance;
+ (void)setAlias:(NSString *)alias;
- (void)didReceiveRemoteNotification:(NSDictionary *)notification;

@end

#define JPushManagerAppDelegateMethods \
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {\
    [APService registerDeviceToken:deviceToken];\
}\
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {\
    [APService handleRemoteNotification:userInfo];\
}
