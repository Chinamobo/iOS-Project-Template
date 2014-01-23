/**
    APIUserPlugin
    用户插件，用于添加用户支持

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

@class API;

@interface APIUserPlugin : RFPlugin

#pragma mark - 用户信息
@property (assign, nonatomic) int userID;
@property (copy, nonatomic) NSString *userAccount;
@property (copy, nonatomic) NSString *userPassword;
@property (strong, nonatomic) UserInformation *otherUserInformation;

@property (copy, nonatomic) NSString *token;

#pragma mark - 设置
/// Default `NO`
@property (assign, nonatomic) BOOL shouldRememberPassword;

/// Default `NO`
@property (assign, nonatomic) BOOL shouldAutoLogin;

/// Default `NO`
@property (assign, nonatomic) BOOL shouldAutoFetchOtherUserInformationAfterLogin;

/// userAccount, userPassword, shouldRememberPassword, shouldAutoLogin 字段保存/重置
- (void)saveProfileConfig;
- (void)resetProfileConfig;

#pragma mark -
#pragma mark 登陆

// 是否已登入
@property (readonly, nonatomic) BOOL isLoggedIn;

// 正在登入
@property (readonly, nonatomic) BOOL isLogining;
//登陆接口
- (void)loginWithCallback:(void (^)(BOOL success, NSError *error))callback;

- (void)logout;

#pragma mark 用户信息获取
@property (readonly, nonatomic) BOOL isFetchingUserInformation; // 只对当前用户有效

- (void)fetchUserInfoWithID:(int)userID completion:(void (^)(UserInformation *info, NSError *error))callback;

#pragma mark 找回密码
- (void)resetPasswordWithInfo:(NSDictionary *)recoverInfo completion:(void (^)(NSString *password, NSError *error))callback;

@end
