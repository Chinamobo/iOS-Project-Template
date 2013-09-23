/*!
    AFNetworking 扩展

    将成功和失败两个回调合并为一个
    使用 AFJSONRequestOperation 执行请求，并直接返回解析好的 JSON 对象
 */

#import "AFNetworking.h"

@interface AFHTTPClient (API)

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(AFJSONRequestOperation *operation, id JSONObject, NSError *error))callback;

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(AFJSONRequestOperation *operation, id JSONObject, NSError *error))callback;

// 上传文件的便利方法
- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters attachFiles:(void (^)(id <AFMultipartFormData> formData))bodyConstructBlock uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock completion:(void (^)(AFJSONRequestOperation *operation, id JSONObject, NSError *error))callback;

@end
