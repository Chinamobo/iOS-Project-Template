
#import "APIUserPlugin.h"
#import "API.h"

NSString *const UDkLastUserAccount = @"Last User Account";
NSString *const UDkUserPass = @"User Password";
NSString *const UDkUserRemeberPass = @"Should Remember User Password";
NSString *const UDkUserAutoLogin = @"Should Auto Login Into User Profile";

@interface APIUserPlugin ()
@property (weak, nonatomic) API *master;
@property (strong, nonatomic) NSUserDefaults *userDefaults; // Not used

@property (readwrite, nonatomic) BOOL isLoggedIn;
@property (readwrite, nonatomic) BOOL isLogining;
@property (readwrite, nonatomic) BOOL isFetchingUserInformation;

@end

@implementation APIUserPlugin

- (id)init {
    RFAssert(false, @"You should call initWithMaster: instead.");
    return nil;
}

- (void)onInit {
    [super onInit];
    
    self.token = @"";
    [self loadProfileConfig];
}

- (void)afterInit {
    [super afterInit];
    
    if (self.shouldAutoLogin) {
        [self loginWithCallback:nil];
    }
}

#pragma mark - 登入

- (void)loginWithCallback:(void (^)(BOOL success, NSError *error))callback {
    if (self.isLoggedIn || self.isLogining) return;
    
    if (!self.userAccount.length || !self.userPassword.length) {
        if (callback) {
            callback(NO, [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier code:1 userInfo:@{NSLocalizedDescriptionKey: @"User Name or Password is nil"}]);
        }
        return;
    }
    
    self.isLogining = YES;
    
    [self.master postPath:APIURLLogin parameters:@{
         @"username" : self.userAccount,
         @"password" : self.userPassword
     } completion:^(AFJSONRequestOperation *operation, id JSONObject, NSError *error) {
         BOOL isSuccess = NO;
         NSError __autoreleasing *e = error;

         if ([JSONObject isKindOfClass:[NSDictionary class]]) {
             self.userID = [JSONObject[@"uid"] intValue];
             self.token = JSONObject[@"token"];
             
             if (self.userID) {
                 [self saveProfileConfig];
                 isSuccess = YES;
                 self.isLoggedIn = YES;
             }
             else {
                 e = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier code:0 userInfo:@{ NSLocalizedDescriptionKey: JSONObject[@"result"] }];
             }
         }
         
         if (callback) {
             callback(isSuccess, e);
         }
         
         if (self.shouldAutoFetchOtherUserInformationAfterLogin) {
             [self fetchUserInformationCompletion:nil];
         }
         
         self.isLogining = NO;
     }];
}

- (void)logout {
    self.isLoggedIn = NO;
    self.userID = 0;
    [self resetProfileConfig];
}

#pragma mark -
- (void)resetPasswordWithInfo:(NSDictionary *)recoverInfo completion:(void (^)(NSString *password, NSError *error))callback{
    [self.master postPath:APIURLForgetPassword parameters:recoverInfo completion:^(AFJSONRequestOperation *operation, id JSONObject, NSError *Error) {
        if (JSONObject) {
            if ([JSONObject[@"Result"] isEqualToString:@"0"]) {
                callback(JSONObject[@"password"], nil);
            }
            else {
                callback(nil, Error);
            }
        }
        else {
            callback(nil, Error);
        }
    }];
}

#pragma mark -
- (void)fetchUserInformationCompletion:(void (^)(BOOL success, NSError *))callback {
    if (self.userID) {
        self.isFetchingUserInformation = YES;
        [self fetchUserInfoWithID:self.userID completion:^(UserInformation *info, NSError *error) {
            self.otherUserInformation = info;
            if (callback) {
                callback(YES, error);
            }
            self.isFetchingUserInformation = NO;
        }];
    }
    else {
        if (callback) {
            NSError __autoreleasing *e = [[NSError alloc] initWithDomain:@"this" code:0 userInfo:@{ NSLocalizedDescriptionKey : @"未登陆" }];
            callback(NO, e);
        }
    }
}

- (void)fetchUserInfoWithID:(int)userID completion:(void (^)(UserInformation *info, NSError *error))callback {
    [self.master getPath:APIURLUserInfo parameters:@{
         @"uid" : @(userID),
         @"token" : (self.token)? : @""
     } completion:^(AFJSONRequestOperation *operation, id JSONObject, NSError *error) {
         if (callback) {
             NSError __autoreleasing *e = nil;
             UserInformation *info = [[UserInformation alloc] initWithDictionary:JSONObject error:&e];
             callback(info, (error)? error : e);
         }
     }];
}

#pragma mark - Secret staues
- (void)loadProfileConfig {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.shouldRememberPassword = [ud boolForKey:UDkUserRemeberPass];
    self.shouldAutoLogin = [ud boolForKey:UDkUserAutoLogin];
    self.userAccount = [ud objectForKey:UDkLastUserAccount];
    
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
    [ud setObject:self.userAccount forKey:UDkLastUserAccount];
    [ud setBool:self.shouldRememberPassword forKey:UDkUserRemeberPass];
    [ud setBool:self.shouldAutoLogin forKey:UDkUserAutoLogin];
    
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
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:NO forKey:UDkUserRemeberPass];
    [ud setBool:NO forKey:UDkUserAutoLogin];
    [ud setObject:@"" forKey:UDkUserPass];
    [ud setObject:@"" forKey:UDkLastUserAccount];
    [ud synchronize];
    
#if APIUserPluginUsingKeychainToStroeSecret
    [SSKeychain deletePasswordForService:[NSBundle mainBundle].bundleIdentifier account:self.userAccount];
#endif
}

@end
