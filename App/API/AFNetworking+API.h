/*!
    AFNetworking 扩展

    将成功和失败两个回调合并为一个
    响应作为 JSON 处理
 
    上传、下载进度在返回的 AFHTTPRequestOperation 对象上单独设置就行了
 */

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface AFHTTPRequestOperationManager (API)
// KVO not supported.
@property (readonly, nonatomic, assign) AFNetworkReachabilityStatus networkReachabilityStatus;

#pragma mark -

- (AFHTTPRequestOperation *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(void (^)(AFHTTPRequestOperation *operation, id JSONResponseObject, NSError *error))callback;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(NSDictionary *)formParameters completion:(void (^)(AFHTTPRequestOperation *operation, id JSONResponseObject, NSError *error))callback;

/**
 上传文件的便利方法
 */
- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(NSDictionary *)formParameters attachFiles:(void (^)(id <AFMultipartFormData> formData))bodyConstructBlock completion:(void (^)(AFHTTPRequestOperation *operation, id JSONResponseObject, NSError *error))callback;

#pragma mark -
/**
 创建一个响应为JSON的请求
 */
- (AFHTTPRequestOperation *)JSONRequestOperationWithRequest:(NSURLRequest *)request completion:(void (^)(AFHTTPRequestOperation *operation, id JSONResponseObject, NSError *error))callback;

@end
