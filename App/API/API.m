
#import "debug.h"
#import "API.h"
#import "APIInterface.h"
#import "APIConfig.h"
#import "APIJSONResponseSerializer.h"

#import "AFNetworkActivityLogger.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "NSJSONSerialization+RFKit.h"
#import "NSDateFormatter+RFKit.h"
#import "UIDevice+RFKit.h"
#import "NSFileManager+RFKit.h"

RFDefineConstString(APIErrorDomain);

@interface API ()
<UIAlertViewDelegate>

@property (readwrite, nonatomic) BOOL updating;
- (void)doUpdate;

@end

@implementation API

+ (instancetype)sharedInstance {
	static API* sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
	return sharedInstance;
}

- (instancetype)init {
    self = [self initWithBaseURL:[NSURL URLWithString:APIURLDeployBase]];
    if (!self) return nil;

    NSError __autoreleasing *e = nil;
    NSString *cachePath = [[NSFileManager defaultManager] subDirectoryURLWithPathComponent:@"networking/" inDirectory:NSCachesDirectory createIfNotExist:YES error:&e].path;
    if (e) dout_error(@"%@", e);

    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:5 * 1024 * 1024 diskCapacity:50 * 1024 * 1024 diskPath:cachePath];
    [NSURLCache setSharedURLCache:sharedCache];

    self.responseSerializer = [APIJSONResponseSerializer serializer];

    // 设置属性
    self.user = [[APIUserPlugin alloc] initWithMaster:self];
    self.user.shouldRememberPassword = YES;
    self.user.shouldAutoFetchOtherUserInformationAfterLogin = YES;
    
    self.autoSyncPlugin = [[APIAutoSyncPlugin alloc] initWithMaster:self];
    self.autoSyncPlugin.syncCheckInterval = APIConfigAutoUpdateCheckInterval;
    
    // 配置网络
    if ([UIDevice currentDevice].isBeingDebugged) {
        [[AFNetworkActivityLogger sharedLogger] startLogging];
        [AFNetworkActivityLogger sharedLogger].level = AFLoggerLevelInfo;
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
    
    if (!self.reachabilityManager.reachable) {
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



#pragma mark - Auto sync & App update
+ (NSSet *)keyPathsForValuesAffectingCanPerformSync {
    API *this;
    return [NSSet setWithObjects:@keypath(this, isUpdating), @keypath(this, reachabilityManager.networkReachabilityStatus), nil];
}

- (BOOL)canPerformSync {
    if (!self.isUpdating && self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        return YES;
    }
    return NO;
}

- (void)startSync {
    [self doUpdate];
    self.appUpdatePlugin.showNoticeIfNoUpdateAvailableUsingBuildInNoticeDelegate = NO;
    [self.appUpdatePlugin checkUpdateSilence:YES completion:nil];
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

#pragma mark - 请求方法

- (void)fetch:(NSString *)URI method:(NSString *)method parameters:(NSDictionary *)parameters expectClass:(Class)modelClass success:(void (^)(id JSONModelObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure completion:(void (^)(AFHTTPRequestOperation *operation))completion {
    if (!method) method = @"GET";

    [self requestWithMethod:method URLString:URI parameters:parameters headers:nil expectObjectClass:modelClass success:^(AFHTTPRequestOperation *operation, id JSONModelObject) {
        success(JSONModelObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
        else {
            [self alertError:error title:nil];
        }
    } completion:completion];
}

- (void)fetchList:(NSString *)URI method:(NSString *)method parameters:(NSDictionary *)parameters expectClass:(Class)modelClass success:(void (^)(NSMutableArray *JSONModelObjects))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure completion:(void (^)(AFHTTPRequestOperation *operation))completion {
    if (!method) method = @"GET";

    [self requestWithMethod:method URLString:URI parameters:parameters headers:nil expectArrayContainsClass:modelClass success:^(AFHTTPRequestOperation *operation, NSMutableArray *objects) {
        success(objects);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
        else {
            [self alertError:error title:nil];
        }
    } completion:completion];
}

- (void)send:(NSString *)URI parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure completion:(void (^)(AFHTTPRequestOperation *operation))completion {
    [self requestWithMethod:@"POST" URLString:URI parameters:parameters headers:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
        else {
            [self alertError:error title:nil];
        }
    } completion:completion];
}

#pragma mark - 统一错误处理

- (void)alertError:(NSError *)error title:(NSString *)title {
    NSMutableString *message = [NSMutableString string];
    if (error.localizedDescription) {
        [message appendFormat:@"%@\n", error.localizedDescription];
    }
    if (error.localizedFailureReason) {
        [message appendFormat:@"%@\n", error.localizedFailureReason];
    }
    if (error.localizedRecoverySuggestion) {
        [message appendFormat:@"%@\n", error.localizedRecoverySuggestion];
    }
#if RFDEBUG
    dout_error(@"Error: %@ (%d), URL:%@", error.domain, error.code, error.userInfo[NSURLErrorFailingURLErrorKey]);
#endif

    [UIAlertView showWithTitle:title? : @"不能完成请求" message:message buttonTitle:@"确定"];
}

@end

