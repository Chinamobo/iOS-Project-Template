
#import "debug.h"
#import "API.h"
#import "APIConfig.h"
#import "APIJSONResponseSerializer.h"
#import "RFSVProgressMessageManager.h"

#import "AFNetworkActivityLogger.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "NSJSONSerialization+RFKit.h"
#import "NSDateFormatter+RFKit.h"
#import "UIDevice+RFKit.h"
#import "NSFileManager+RFKit.h"

RFDefineConstString(APIErrorDomain);

@interface API () <
    UIAlertViewDelegate
>

@end

@implementation API

+ (APIUserPlugin *)user {
    return [API sharedInstance].user;
}

- (void)onInit {
    [super onInit];

    // 接口总体设置
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"APIDefine" ofType:@"plist"];
    NSDictionary *rules = [[NSDictionary alloc] initWithContentsOfFile:configPath];
    [self.defineManager setDefinesWithRulesInfo:rules];
    self.defineManager.defaultRequestSerializer = [AFJSONRequestSerializer serializer];
    self.defineManager.defaultResponseSerializer = [APIJSONResponseSerializer serializer];
    self.maxConcurrentOperationCount = 2;

    // 设置属性
    self.user = [[APIUserPlugin alloc] initWithMaster:self];
//    self.user.shouldKeepLoginStatus = YES;
    self.user.shouldRememberPassword = YES;
    self.user.shouldAutoLogin = NO;

    self.networkActivityIndicatorManager = [RFSVProgressMessageManager new];

    // 配置网络
    if ([UIDevice currentDevice].isBeingDebugged) {
        [[AFNetworkActivityLogger sharedLogger] startLogging];
        [AFNetworkActivityLogger sharedLogger].level = AFLoggerLevelInfo;
    }
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

#pragma mark - 通用流程

- (BOOL)generalHandlerForError:(NSError *)error withDefine:(RFAPIDefine *)define controlInfo:(RFAPIControl *)controlInfo requestOperation:(AFHTTPRequestOperation *)operation operationFailureCallback:(void (^)(AFHTTPRequestOperation *, NSError *))operationFailureCallback {
    if ([error.domain isEqualToString:RFAPIErrorDomain] && error.code == 3) {
        [self.networkActivityIndicatorManager alertError:error title:@"请重新登录"];
        dispatch_after_seconds(1, ^{
            [self.user logout];
        });
        return NO;
    }
    return YES;
}

+ (AFHTTPRequestOperation *)requestWithName:(NSString *)APIName parameters:(NSDictionary *)parameters viewController:(UIViewController *)viewController loadingMessage:(NSString *)message modal:(BOOL)modal success:(void (^)(AFHTTPRequestOperation *, id))success completion:(void (^)(AFHTTPRequestOperation *))completion {
    RFAPIControl *cn = [[RFAPIControl alloc] init];
    if (message) {
        cn.message = [[RFNetworkActivityIndicatorMessage alloc] initWithIdentifier:APIName title:nil message:message status:RFNetworkActivityIndicatorStatusLoading];
        cn.message.modal = modal;
    }
    cn.identifier = APIName;
    cn.groupIdentifier = NSStringFromClass(viewController.class);
    return [[self sharedInstance] requestWithName:APIName parameters:parameters controlInfo:cn success:success failure:nil completion:completion];
}

+ (void)showSuccessStatus:(NSString *)message {
    [[API sharedInstance].networkActivityIndicatorManager showWithTitle:nil message:message status:RFNetworkActivityIndicatorStatusSuccess modal:NO priority:RFNetworkActivityIndicatorMessagePriorityHigh autoHideAfterTimeInterval:0 identifier:nil groupIdentifier:nil userInfo:nil];
}

#pragma mark - 具体业务


#pragma mark - App update

- (APIAppUpdatePlugin *)appUpdatePlugin {
    if (!_appUpdatePlugin) {
        APIAppUpdatePlugin *up = [[APIAppUpdatePlugin alloc] initWithMaster:self];
        up.enterpriseDistributionPlistURL = [NSURL URLWithString: APIConfigEnterpriseDistributionURL];
        _appUpdatePlugin = up;
    }
    return _appUpdatePlugin;
}

@end

#import "UIImageView+WebCache.h"

@implementation UIImageView (App)

- (void)setImageWithURLString:(NSString *)path placeholderImage:(UIImage *)placeholder {
    NSURL *url = [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:APIURLAssetsBase]];
    placeholder = placeholder?: self.image;
    [self setImageWithURL:url placeholderImage:placeholder];
}

@end
