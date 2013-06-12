
#import "debug.h"
#import "API.h"
#import "APIInterface.h"

#import "AFHTTPRequestOperationLogger.h"

#import "NSJSONSerialization+RFKit.h"
#import "NSDateFormatter+RFKit.h"
#import "UIDevice+RFKit.h"
#import "UIAlertView+RFKit.h"


@interface API ()
<UIAlertViewDelegate>

@property (readwrite, nonatomic) BOOL updating;
- (void)doUpdate;

@end

@implementation API

+ (void)load {
    @autoreleasepool {
        NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:1 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:[[NSBundle mainBundlePathForCaches] stringByAppendingPathComponent:@".urlCache"]];
        [NSURLCache setSharedURLCache:URLCache];
    }
}

#pragma mark - Property
- (NSString *)macAddress {
    static NSString *_macAddress = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _macAddress = (DebugAPIEnableTestProfile)? DebugAPITestProfileMacAddress : [[UIDevice currentDevice] macAddress];
    });
	return _macAddress;
}

#pragma mark -
+ (instancetype)sharedInstance {
	static API* sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
	return sharedInstance;
}

- (id)init {
    self = [self initWithBaseURL:[NSURL URLWithString:APIURLDeployBase]];
    if (!self) return nil;
    
    // 设置属性
    self.autoSyncPlugin = [[APIAutoSyncPlugin alloc] initWithMaster:self];
    self.autoSyncPlugin.syncCheckInterval = APIConfigAutoUpdateCheckInterval;
    
    // 配置网络
    if (RFDEBUG) {
        [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
        [AFHTTPRequestOperationLogger sharedLogger].level = AFLoggerLevelInfo;
    }
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // 后续操作
    [self contextCheck];
    
    return self;
}

#pragma mark - 通用流程
// API 初始化后的检查
- (void)contextCheck {
    @autoreleasepool {
        
    }
}

- (void)requestUpdate {
    if (!self.isUpdating) {
        [self doUpdate];
    }
}

- (void)doUpdate {
    self.updating = YES;
    
    if (self.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [UIAlertView showWithTitle:@"提示" message:@"可能尚未联网，请检查你的网络连接" buttonTitle:@"OK"];
    }
    
    // TODO: 更新操作
}

/// 执行更新后的工作，需保证必定能被调用
- (void)afterUpdate {
    dout_info(@"更新完毕")
    [self.autoSyncPlugin syncFinshed:YES];
    
    self.updating = NO;
}

#pragma mark - 具体业务
// TODO: 用户信息存取，而且直接放UserDefault极不安全
- (void)loginWithUserName:(NSString *)name pass:(NSString *)pass callback:(void (^)(BOOL success, NSString *message))callback {
    if (!DebugAPIEnableTestProfile) {
        RFAssert(name, @"用户名不能为空");
        RFAssert(pass, @"密码不能为空");
    }
    
    if (self.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable) {
        [self postPath:APIURLLogin parameters:@{
             @"login" : (DebugAPIEnableTestProfile)? DebugAPITestProfileName : name,
             @"password" : (DebugAPIEnableTestProfile)? DebugAPITestProfilePassword : pass,
             @"mac_address" : self.macAddress
         } success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *info = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
             douto(info)
             if ([info boolForKey:@"status"]) {
                 callback(YES, info[@"msg"]);
             }
             else {
                 callback(NO, info[@"msg"]);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             callback(NO, error.localizedDescription);
         }];
    }
    else {
        // 离线登陆
        if (APIConfigOfflineLoginEnabled) {
            if ([[[NSUserDefaults standardUserDefaults] stringForKey:UDkUserName] isEqualToString:name]
                && [[[NSUserDefaults standardUserDefaults] stringForKey:UDkUserPass] isEqualToString:pass]) {
                callback(YES, @"OK");
            }
            else {
                callback(NO, @"用户名与密码不匹配");
            }
        }
        else {
            callback(NO, @"无网络连接");
        }
    }
}

#pragma mark - Auto sync
+ (NSSet *)keyPathsForValuesAffectingCanPerformSync {
    API *this;
    return [NSSet setWithObjects:@keypath(this, isUpdating), @keypath(this, networkReachabilityStatus), nil];
}

- (BOOL)canPerformSync {
    if (!self.isUpdating && self.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        return YES;
    }
    return NO;
}

- (void)startSync {
    [self doUpdate];
    self.appUpdatePlugin.showNoticeIfNoUpdateAvailableUsingBuildInNoticeDelegate = NO;
    [self.appUpdatePlugin checkUpdate];
}

- (void)clearAfterSync {
    self.autoSyncPlugin = nil;
    self.appUpdatePlugin = nil;
}

- (APIAppUpdatePlugin *)appUpdatePlugin {
    if (!_appUpdatePlugin) {
        APIAppUpdatePlugin *up = [[APIAppUpdatePlugin alloc] initWithMaster:self];
        up.appStoreID = APIConfigAppStroeID;
        up.enterpriseDistributionPlistURL = [NSURL URLWithString: APIConfigEnterpriseDistributionURL];
        _appUpdatePlugin = up;
    }
    return _appUpdatePlugin;
}

#pragma mark - Debug method
- (id)localTestJSONObjectFromAPIURL:(NSString *)APIURL {
    NSString *fileName = [APIURL lastPathComponent];
    NSParameterAssert(fileName);
    NSString *localFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json" inDirectory:@"TestData"];
    NSInputStream *fileStream = [NSInputStream inputStreamWithFileAtPath:localFilePath];
    NSError __autoreleasing *e = nil;
    [fileStream open];
    id obj = [NSJSONSerialization JSONObjectWithStream:fileStream options:NSJSONReadingAllowFragments error:&e];
    [fileStream close];
    if (e) dout_error(@"%@", e);
    return obj;
}

@end

