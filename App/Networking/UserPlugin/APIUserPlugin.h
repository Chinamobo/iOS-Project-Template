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

@class API, AFHTTPRequestOperation;

@interface APIUserPlugin : RFPlugin

- (instancetype)initWithMaster:(API *)master;

#pragma mark - 用户信息
@property (copy, nonatomic) NSString *account;
@property (copy, nonatomic) NSString *userPassword;
@property (strong, nonatomic) UserInformation *information;

@property (copy, nonatomic) NSString *token;

#pragma mark - 设置
/// 保持登录状态，下次启动不走登录流程。默认 `NO`
@property (assign, nonatomic) BOOL shouldKeepLoginStatus;

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
- (void)loginWithSuccessCallback:(void (^)(void))success completion:(void (^)(AFHTTPRequestOperation *operation))completion;

- (void)logout;

#pragma mark 用户信息获取
@property (readonly, nonatomic) BOOL isFetchingUserInformation; // 只对当前用户有效

- (void)fetchUserInfoWithID:(int)userID completion:(void (^)(UserInformation *info, NSError *error))callback;

#pragma mark 找回密码
- (void)resetPasswordWithInfo:(NSDictionary *)recoverInfo completion:(void (^)(NSString *password, NSError *error))callback;

@end
