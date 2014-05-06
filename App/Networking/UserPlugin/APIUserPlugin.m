
#import "APIUserPlugin.h"
#import "API.h"
#import "debug.h"

NSString *const UDkLastUserAccount      = @"Last User Account";
NSString *const UDkUserPass             = @"User Password";
NSString *const UDkUserRemeberPass      = @"Should Remember User Password";
NSString *const UDkUserInformation      = @"User Information";

@interface APIUserPlugin ()
@property (weak, nonatomic) API *master;
@property (strong, nonatomic) NSUserDefaults *userDefaults; // Not used

@property (readwrite, nonatomic) BOOL isLoggedIn;
@property (readwrite, nonatomic) BOOL isLogining;
@property (readwrite, nonatomic) BOOL isFetchingUserInformation;

@end

@implementation APIUserPlugin

- (instancetype)init {
    RFAssert(false, @"You should call initWithMaster: instead.");
    return nil;
}

- (instancetype)initWithMaster:(API *)master {
    self = [super init];
    if (self) {
        self.master = master;
        [self onInit];
        [self performSelector:@selector(afterInit) withObject:self afterDelay:0];
    }
    return self;
}

- (void)onInit {
    [super onInit];
    
    [self loadProfileConfig];

    if (self.information || DebugAPISkipLogin) {
        self.isLoggedIn = YES;
    }
}

- (void)afterInit {
    [super afterInit];
    
    if (!self.isLoggedIn && self.shouldAutoLogin &&
        self.account && self.userPassword) {
        [self loginWithSuccessCallback:nil completion:nil];
    }
}

#pragma mark - 登入

- (void)loginWithSuccessCallback:(void (^)(void))success completion:(void (^)(AFHTTPRequestOperation *operation))completion {

    if (self.isLoggedIn || self.isLogining) return;

    RFAssert(self.account.length, @"账户未指定");
    RFAssert(self.userPassword.length, @"密码未指定");
    
    self.isLogining = YES;

    [API requestWithName:APIURLLogin parameters:@{
        @"username" : self.account,
        @"password" : self.userPassword
    } viewController:nil loadingMessage:@"正在登录…" modal:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // TODO: 根据返回赋值
        [self saveProfileConfig];
        self.isLoggedIn = YES;

        if (success) {
            success();
        }

        if (self.shouldAutoFetchOtherUserInformationAfterLogin) {
            [self fetchUserInformationCompletion:nil];
        }
    } completion:^(AFHTTPRequestOperation *operation) {
        self.isLogining = NO;

        if (completion) {
            completion(operation);
        }
    }];
}

- (void)logout {
    self.isLoggedIn = NO;
    [self resetProfileConfig];

    // 其他清理
}

#pragma mark -
- (void)fetchUserInformationCompletion:(void (^)(BOOL success, NSError *))callback {

}

#pragma mark -
- (void)resetPasswordWithInfo:(NSDictionary *)recoverInfo completion:(void (^)(NSString *password, NSError *error))callback {

	RFAPIControl *cn = [[RFAPIControl alloc] initWithIdentifier:APIURLResetPassword loadingMessage:@"提交重置密码请求..."];
	cn.message.modal = YES;
	[self.master requestWithName:APIURLResetPassword parameters:recoverInfo controlInfo:cn success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback) {
            callback(responseObject, nil);
        }
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callback) {
            callback(nil, error);
        }
	} completion:nil];
}

#pragma mark - Secret staues
- (void)loadProfileConfig {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.shouldRememberPassword = [ud boolForKey:UDkUserRemeberPass];
    self.account = [ud objectForKey:UDkLastUserAccount];
    
    if (self.shouldRememberPassword) {
#if APIUserPluginUsingKeychainToStroeSecret
        NSError __autoreleasing *e = nil;
        self.userPassword = [SSKeychain passwordForService:[NSBundle mainBundle].bundleIdentifier account:self.userAccount error:&e];
        if (e) dout_error(@"%@", e);
#else
        self.userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:UDkUserPass];
#endif
    }
}

- (void)saveProfileConfig {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.account forKey:UDkLastUserAccount];
    [ud setBool:self.shouldRememberPassword forKey:UDkUserRemeberPass];

#if APIUserPluginUsingKeychainToStroeSecret
    if (self.shouldRememberPassword) {
        NSError __autoreleasing *e = nil;
        [SSKeychain setPassword:self.userPassword forService:[NSBundle mainBundle].bundleIdentifier account:self.userAccount error:&e];
        if (e) dout_error(@"%@", e);
    }
    else {
        [SSKeychain deletePasswordForService:[NSBundle mainBundle].bundleIdentifier account:self.userAccount];
    }
#else
    if (self.shouldRememberPassword) {
        [ud setObject:self.userPassword forKey:UDkUserPass];
    }
    else {
        [ud removeObjectForKey:UDkUserPass];
    }
#endif
    
    [ud synchronize];
}

- (void)resetProfileConfig {
    self.userPassword = nil;
    self.information = nil;

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:NO forKey:UDkUserRemeberPass];
    [ud removeObjectForKey:UDkUserPass];
    [ud removeObjectForKey:UDkLastUserAccount];
    [ud removeObjectForKey:UDkUserInformation];
    [ud synchronize];
    
#if APIUserPluginUsingKeychainToStroeSecret
    [SSKeychain deletePasswordForService:[NSBundle mainBundle].bundleIdentifier account:self.userAccount];
#endif
}

@end
