/**
    API
    网络基础及接口封装
 
    接口地址在 APIInterface.h 中配置
    尽量不要直接使用 AFHTTPClient 或更低级的 request 对象
    多用封装好的业务方法
    如果有像UserID这种东西，让API来管理，不要在外面获取再传进来
 */

#import "DataStack.h"
#import "AFNetworking.h"
#import "APIAutoSyncPlugin.h"
#import "APIAppUpdatePlugin.h"

@interface API : AFHTTPClient
<APIAutoSyncPluginDelegate>

+ (API *)sharedInstance;

#pragma mark - 状态与通用流程
@property (readonly, nonatomic) NSString *macAddress;

// 请求执行通用的更新流程
- (void)requestUpdate;
@property (readonly, nonatomic, getter = isUpdating) BOOL updating;


#pragma mark - 具体业务
- (void)loginWithUserName:(NSString *)name pass:(NSString *)pass callback:(void (^)(BOOL success, NSString *message))callback;

#pragma mark - 自动更新
@property (strong, nonatomic) APIAutoSyncPlugin *autoSyncPlugin;
@property (readonly, assign, nonatomic) BOOL canPerformSync;

@property (strong, nonatomic) APIAppUpdatePlugin *appUpdatePlugin;

@end

// 暴漏给外部的常量
extern NSString *const UDkUserName;

