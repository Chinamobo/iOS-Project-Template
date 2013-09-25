
#import "debug.h"
#import "API.h"
#import "APIInterface.h"

#import "AFHTTPRequestOperationLogger.h"
#import "NSJSONSerialization+RFKit.h"
#import "NSDateFormatter+RFKit.h"
#import "UIDevice+RFKit.h"
#import "NSFileManager+RFKit.h"

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
    
//    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    // 设置属性
    self.user = [[APIUserPlugin alloc] initWithMaster:self];
    self.user.shouldRememberPassword = YES;
    self.user.shouldAutoFetchOtherUserInformationAfterLogin = YES;
    
    self.autoSyncPlugin = [[APIAutoSyncPlugin alloc] initWithMaster:self];
    self.autoSyncPlugin.syncCheckInterval = APIConfigAutoUpdateCheckInterval;
    
    // 配置网络
    if ([UIDevice currentDevice].isBeingDebugged) {
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



#pragma mark - Auto sync & App update
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

#pragma mark - 统一错误处理

- (void)alertError:(NSError *)error title:(NSString *)title {
    NSString *message = error.localizedDescription.length? error.localizedDescription : nil;
    [UIAlertView showWithTitle:title? : @"不能完成请求" message:message buttonTitle:@"确定"];
}

@end

