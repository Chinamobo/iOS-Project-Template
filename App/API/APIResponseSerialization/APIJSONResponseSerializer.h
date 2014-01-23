/*!
    APIJSONResponseSerializer

    Copyright (c) 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo
 
    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "AFURLResponseSerialization.h"
#import "JSONModel.h"

/** 统一的 API 接口解析器
 
 这个解析器只适用于JSON接口，图像获取、文件下载等场景不适用
 
 关于错误处理
 --------

 默认情形，这个解析器会处理大部分底层的错误，处理的错误类型：
 - HTTP status code 不正确
 - HTTP Content-Type 不正确
 - 返回内容为空
 - 不能按 JSON 解析
 - 返回是约定的报错方式
 
 拿到的 responseObject 符不符合相应的 model 需要再做相应判断。
 
 如果服务器通过 HTTP status code 报告请求错误，另见 serverReportErrorUsingStatusCode 属性
 
 关于回调返回的 NSError
 -------
 
 服务器如果通过接口返回错误信息，回调中的 NSError 的 error domain 应为  APIErrorDomain，其它属于网络部分的错误 error domain 应该是 NSURLErrorDomain。
 
 这个错误信息在 debug 和 release 模式中会有不同的输出，这个错误对象除了能响应正常的 localizedDescription 外，localizedRecoverySuggestion 和 localizedFailureReason 也会有输出，userInfo[NSURLErrorFailingURLErrorKey] 中会包含请求的 URL，但是不保证是 NSURL 对象，也可能是 NSString。

 FAQ
 --------
 
 * 如何支持 HTML content-type?
   请修改 acceptableContentTypes 属性

 */
@interface APIJSONResponseSerializer : AFHTTPResponseSerializer
+ (instancetype)sharedInstance;

/** 服务器是否通过 HTTP status code 报告请求错误

 典型的如新浪微博API。
 默认 `NO`，使用 acceptableStatusCodes 做检查，默认实现接受 200~299
 设为 `YES` 将允许 HTTP status code 为 400~499，具体错误信息需要服务器在返回内容中注明
 */
@property (assign, nonatomic) BOOL serverReportErrorUsingStatusCode;

@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

@end

/** 接口返回错误模型
 
 需要根据服务器的约定做相应修改
 
 建议重写的方法：

 - + (JSONKeyMapper *)keyMapper;
 - + (NSString *)localizedDescriptionKeyForErrorCode:(int)errorCode;

 */
@interface APIJSONError : JSONModel
/// 接口返回的错误描述
@property (copy, nonatomic) NSString *errorDescription;

/** 错误信息
 
 该方法首先通过 errorCode 查找对应的错误信息，如果不存在尝试使用 errorDescription，
 如果 errorDescription 也为 nil，将返回一个空字符串，而不是 nil

 @return 该对象对应的错误描述，始终不会是 nil
 */
- (NSString *)localizedDescription;

/// 接口返回的错误码
@property (assign, nonatomic) int errorCode;

/** 根据错误码返回相应错误信息
 
 默认实现全部返回 nil
 
 @param errorCode 接口返回的错误码

 @return 错误码对应的错误信息
 */
+ (NSString *)localizedDescriptionKeyForErrorCode:(int)errorCode;


@end
