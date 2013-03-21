/**
    API
    网络基础及接口封装
 
    接口地址在 config.plist 中配置
    尽量不要直接使用 AFHTTPClient 或更低级的 request 对象
    多使用，封装具体业务
 */

#import "DataStack.h"
#import "AFNetworking.h"

@interface API : NSObject
+ (API *)sharedInstance;

#pragma mark - 状态与通用流程
@property (readonly, nonatomic, getter = isNetworkReachable) BOOL networkReachable;
@property (readonly, nonatomic) NSString *macAddress;
@property (readonly, nonatomic) NSDictionary *configInfo;

// 请求执行通用的更新流程
- (void)requestUpdate;
@property (readonly, nonatomic, getter = isUpdating) BOOL updating;
// 应用启动后，会在网络可用时执行一次自动同步的操作
@property (assign, nonatomic) BOOL hasAutoSynced;


#pragma mark - 具体业务
- (void)loginWithUserName:(NSString *)name pass:(NSString *)pass callback:(void (^)(BOOL success, NSString *message))callback;


#pragma mark - 直接使用网络请求
- (void)getType:(NSString *)APIURLType parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postType:(NSString *)APIURLType parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// 更底层一些的
@property (RF_STRONG, nonatomic) AFHTTPClient *core;
- (NSString *)APIURLPathForType:(NSString *)typeString;


@end

NSString *const APIURLTypeLogin = @"Login";

NSString *const UDkUserName = @"User Name";
NSString *const UDkUserPass = @"User Password";
NSString *const UDkUserRemeberPass = @"User Password Remeber";
