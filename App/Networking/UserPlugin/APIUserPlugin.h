/*!
    APIUserPlugin

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFPlugin.h"
#import "UserInformation.h"

// 用 Keychian 存取用户密码
#ifndef APIUserPluginUsingKeychainToStroeSecret
#   define APIUserPluginUsingKeychainToStroeSecret 0
#endif

#if APIUserPluginUsingKeychainToStroeSecret
#import "SSKeychain.h"
#endif

@class API, AFHTTPRequestOperation;

/**
 用户插件，用于添加用户支持
 */
@interface APIUserPlugin : RFPlugin

- (instancetype)initWithMaster:(API *)master;

#pragma mark - 用户信息
@property (copy, nonatomic) NSString *account;
@property (copy, nonatomic) NSString *password;

/// 除上面两个字段外，其余所有信息请定义在该属性中
@property (strong, nonatomic) UserInformation *information;

#pragma mark - 设置
/// 保持登录状态，下次启动不走登录流程。默认 `NO`
@property (assign, nonatomic) BOOL shouldKeepLoginStatus;

/// Default `NO`
@property (assign, nonatomic) BOOL shouldRememberPassword;

/// Default `NO`
@property (assign, nonatomic) BOOL shouldAutoLogin;

/// Default `NO`
@property (assign, nonatomic) BOOL shouldAutoFetchOtherUserInformationAfterLogin;

/// account, password, shouldRememberPassword 字段保存/重置
- (void)saveProfileConfig;
- (void)resetProfileConfig;

#pragma mark -
#pragma mark 登陆

/// 是否已登入
@property (readonly, nonatomic) BOOL loggedIn;

/// 正在登入
@property (readonly, nonatomic) BOOL logining;

- (void)loginWithSuccessCallback:(void (^)(void))success completion:(void (^)(AFHTTPRequestOperation *operation))completion;
- (void)logout;

#pragma mark 用户信息获取
@property (readonly, nonatomic) BOOL fetchingUserInformation;

- (void)fetchUserInformationCompletion:(void (^)(BOOL success, NSError *))callback;

#pragma mark 找回密码
- (void)resetPasswordWithInfo:(NSDictionary *)recoverInfo completion:(void (^)(NSString *password, NSError *error))callback;

@end
