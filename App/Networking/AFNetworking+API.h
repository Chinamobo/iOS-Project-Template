/*!
    AFNetworking 扩展

    将成功和失败两个回调合并为一个
    响应作为 JSON 处理
 
    上传、下载进度在返回的 AFHTTPRequestOperation 对象上单独设置就行了
 */

#import "AFHTTPRequestOperationManager.h"
#import "JSONModel.h"

@interface AFHTTPRequestOperationManager (API)

/** 创建并执行请求，期望的返回是一个数组

 @param method      HTTP 请求模式
 @param URLString   请求的相对地址
 @param parameters  请求参数，可为空
 @param headers     附加的 HTTP header，可为空
 @param modelClass  数组中期望的元素的 JSONModel 类型
 @param success     请求成功回调的 block，可为空
 @param failure     请求失败回调的 block，可为空
 @param completion  请求完成回掉的 block，必定会被调用（即使请求创建失败），会在 success 和 failure 回调后执行。被设计用来执行通用的清理。可为空
 */
- (AFHTTPRequestOperation *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers expectArrayContainsClass:(Class)modelClass success:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray *objects))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure completion:(void (^)(AFHTTPRequestOperation *operation))completion;

/** 创建并执行请求，期望的返回是一个对象

 @param modelClass 期望的元素的 JSONModel 类型
 */
- (AFHTTPRequestOperation *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers expectObjectClass:(Class)modelClass success:(void (^)(AFHTTPRequestOperation *operation, id JSONModelObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure completion:(void (^)(AFHTTPRequestOperation *operation))completion;

/** 创建并执行请求
 
 @return AFHTTPRequestOperation 对象
 */
- (AFHTTPRequestOperation *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure completion:(void (^)(AFHTTPRequestOperation *operation))completion;

/** 创建 NSURLRequest 对象
 
 @param method HTTP 请求模式，如 `GET`、`POST`。不能为空
 @param URLString 请求路径，相对于 baseURL。不能为空
 @param parameters HTTP 请求的参数
 @param headers 附加的 HTTP header，新加的字段的会覆盖原有的
 @param error 创建请求对象出错时产生的错误
 
 @return 使用当前对象的 requestSerializer 序列好的请求对象
 */
- (NSMutableURLRequest *)URLRequestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers error:(NSError *__autoreleasing *)error;

@end


@interface UIImageView (API)

/** 图像设置便利方法

 @param urlString 图片URL，字符串，不用再转成NSURL对象了。支持相对路径，相对于 APIURLAssetsBase
 @param placeholderImage 加载中显示的图像
 @param requestFailedImage 请求失败时显示的图像，为空不会改变 image view 的图像
 */
- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage requestFailedImage:(UIImage *)requestFailedImage;

/** 图像设置便利方法
 
 使用这个方法，在加载及加载失败时会显示默认的状态图像
 默认图像暂时先再实现里改

 @param urlString 图片URL，字符串，不用再转成NSURL对象了。支持相对路径，相对于 APIURLAssetsBase
 */
- (void)setImageWithURLString:(NSString *)urlString;

@end
