/**
    API
    网络基础及接口封装

    如果有像UserID这种东西，让API来管理，不要在外面获取再传进来
 */

#import "RFAPI.h"
#import "RFMessageManager+RFDisplay.h"
#import "DataStack.h"
#import "APIInterface.h"
#import "AFHTTPRequestOperation.h"

#import "APIUserPlugin.h"
#import "APIAutoSyncPlugin.h"
#import "APIAppUpdatePlugin.h"

@interface API : RFAPI

/**

 @param APIName 接口名，同时会作为请求的 identifier
 @param viewController 请求所属视图，会取到它的 class 名作为请求的 groupIdentifier
 */
+ (AFHTTPRequestOperation *)requestWithName:(NSString *)APIName parameters:(NSDictionary *)parameters viewController:(UIViewController *)viewController loadingMessage:(NSString *)message modal:(BOOL)modal success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success completion:(void (^)(AFHTTPRequestOperation *operation))completion;

/**
 显示一个操作成功的信息，显示一段时间后自动隐藏
 */
+ (void)showSuccessStatus:(NSString *)message;

#pragma mark - 具体业务



#pragma mark - 插件

+ (APIUserPlugin *)user;

@property (strong, nonatomic) APIUserPlugin *user;
@property (strong, nonatomic) APIAppUpdatePlugin *appUpdatePlugin;

@end

// 暴漏给外部的常量
extern NSUInteger APIConfigFetchPageSize;
