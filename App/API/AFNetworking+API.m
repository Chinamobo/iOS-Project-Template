
#import "AFNetworking+API.h"
#import "debug.h"
#import "API.h"
#import "RFRuntime.h"

extern NSString *const APIErrorDomain;

@implementation AFHTTPRequestOperationManager (API)

- (AFHTTPRequestOperation *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers expectArrayContainsClass:(Class)modelClass success:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray *objects))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure completion:(void (^)(AFHTTPRequestOperation *operation))completion {
    RFAssert([modelClass isSubclassOfClass:[JSONModel class]], @"modelClass 必须是 JSONModel");

    return [self requestWithMethod:method URLString:URLString parameters:parameters headers:headers success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:[NSArray class]]) {
            if (failure) {
#if RFDEBUG
                NSString *errorMessage = [NSString stringWithFormat:@"期望的数据类型是数组，而实际是 %@\n", [responseObject class]];
                dout_error(@"%@", errorMessage);
#endif
                failure(operation, [NSError errorWithDomain:APIErrorDomain code:0 userInfo:@{
                    NSLocalizedDescriptionKey : @"返回数据异常",
                    NSLocalizedFailureReasonErrorKey : @"可能服务器正在升级或者维护，也可能是应用bug",
                    NSLocalizedRecoverySuggestionErrorKey : @"建议稍后重试，如果持续报告这个错误请检查应用是否有新版本",
                    NSURLErrorFailingURLErrorKey : operation.request.URL
                }]);
            }
            return;
        }

        NSError __autoreleasing *e = nil;
        NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[responseObject count]];
        for (NSDictionary *info in responseObject) {
            id obj = [[modelClass alloc] initWithDictionary:info error:&e];
            if (obj) {
                [objects addObject:obj];
            }
            else {
                if (failure) {
#if RFDEBUG
                    NSString *errorMessage = [NSString stringWithFormat:@"不能将数组中的元素转换为Model %@\n请先确认一下代码，如果服务器没按要求返回请联系后台人员", e];
                    dout_error(@"%@", errorMessage);
#endif
                    failure(operation, [NSError errorWithDomain:APIErrorDomain code:0 userInfo:@{
                        NSLocalizedDescriptionKey : @"返回数据异常",
                        NSLocalizedFailureReasonErrorKey : @"可能服务器正在升级或者维护，也可能是应用bug",
                        NSLocalizedRecoverySuggestionErrorKey : @"建议稍后重试，如果持续报告这个错误请检查应用是否有新版本",
                        NSURLErrorFailingURLErrorKey : operation.request.URL
                    }]);
                }
                return;
            }
        }

        if (success) {
            success(operation, objects);
        }
    } failure:failure completion:completion];
}

- (AFHTTPRequestOperation *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers expectObjectClass:(Class)modelClass success:(void (^)(AFHTTPRequestOperation *operation, id JSONModelObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure completion:(void (^)(AFHTTPRequestOperation *operation))completion {
    RFAssert([modelClass isSubclassOfClass:[JSONModel class]], @"modelClass 必须是 JSONModel");

    return [self requestWithMethod:method URLString:URLString parameters:parameters headers:headers success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (failure) {
#if RFDEBUG
                NSString *errorMessage = [NSString stringWithFormat:@"期望的数据类型是字典，而实际是 %@\n请先确认一下代码，如果服务器没按要求返回请联系后台人员", [responseObject class]];
                dout_error(@"%@", errorMessage);
#endif
                failure(operation, [NSError errorWithDomain:APIErrorDomain code:0 userInfo:@{
                    NSLocalizedDescriptionKey : @"返回数据异常",
                    NSLocalizedFailureReasonErrorKey : @"可能服务器正在升级或者维护，也可能是应用bug",
                    NSLocalizedRecoverySuggestionErrorKey : @"建议稍后重试，如果持续报告这个错误请检查应用是否有新版本",
                    NSURLErrorFailingURLErrorKey : operation.request.URL
                }]);
            }
            return;
        }

        NSError __autoreleasing *e = nil;
        id JSONModelObject = [[modelClass alloc] initWithDictionary:responseObject error:&e];
        if (!JSONModelObject) {
            if (failure) {
#if RFDEBUG
                NSString *errorMessage = [NSString stringWithFormat:@"不能将返回内容转换为Model：%@\n请先确认一下代码，如果服务器没按要求返回请联系后台人员", e];
                dout_error(@"%@", errorMessage);
#endif
                failure(operation, [NSError errorWithDomain:APIErrorDomain code:0 userInfo:@{
                    NSLocalizedDescriptionKey : @"返回数据异常",
                    NSLocalizedFailureReasonErrorKey : @"可能服务器正在升级或者维护，也可能是应用bug",
                    NSLocalizedRecoverySuggestionErrorKey : @"建议稍后重试，如果持续报告这个错误请检查应用是否有新版本",
                    NSURLErrorFailingURLErrorKey : operation.request.URL
                }]);
            }
            return;
        }
        
        if (success) {
            success(operation, JSONModelObject);
        }
    } failure:failure completion:completion];
}

#define __APICompletionCallback(BLOCK, OPERATION, OBJECT)\
    if (BLOCK) {\
        if (DebugAPIDelayFetchCallbackReturnSecond) {\
            dispatch_after_seconds(DebugAPIDelayFetchCallbackReturnSecond, ^{\
                BLOCK(OPERATION, OBJECT);\
            });\
        }\
        else {\
            BLOCK(OPERATION, OBJECT);\
        }\
    }

- (AFHTTPRequestOperation *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure completion:(void (^)(AFHTTPRequestOperation *operation))completion {
    RFAssert(success, @"你确定成功没回调？");
    RFAssert(failure, @"写个接口错误不处理？");

    NSError *e = nil;
    NSMutableURLRequest *request = [self URLRequestWithMethod:method URLString:URLString parameters:parameters headers:headers error:&e];
    if (e) {
        __APICompletionCallback(failure, nil, e)
        if (completion) {
            completion(nil);
        }
        return nil;
    }

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer;
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id responseObject) {
        __APICompletionCallback(success, op, responseObject)
        if (completion) {
            completion(op);
        }
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        __APICompletionCallback(failure, op, error)
        if (completion) {
            completion(op);
        }
    }];

    [self.operationQueue addOperation:operation];
    return operation;
}

#undef __APICompletionCallback

- (NSMutableURLRequest *)URLRequestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers error:(NSError *__autoreleasing *)error {
    NSParameterAssert(method);
    NSParameterAssert(URLString);

    NSURL *url = [NSURL URLWithString:URLString relativeToURL:self.baseURL];
    if (!url) {
        if (error) {
#if RFDEBUG
            NSString *errorMessage = [NSString stringWithFormat:@"无法拼接 URL: %@\n请检查代码是否正确", URLString];
            dout_error(@"%@", errorMessage);
#endif
            *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:@{
                NSLocalizedDescriptionKey : @"内部错误，无法创建请求",
                NSLocalizedFailureReasonErrorKey : @"很可能是应用bug",
                NSLocalizedRecoverySuggestionErrorKey : @"请再试一次，如果依旧请尝试重启应用。给您带来不便，敬请谅解",
                NSURLErrorFailingURLErrorKey : URLString
            }];
        }
        return nil;
    }

    NSURLRequestCachePolicy cachePolicy = (self.reachabilityManager.reachable)? NSURLRequestUseProtocolCachePolicy : NSURLRequestReturnCacheDataElseLoad;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:cachePolicy timeoutInterval:10];
    [request setHTTPMethod:method];

    NSError __autoreleasing *e = nil;
    request = [[self.requestSerializer requestBySerializingRequest:request withParameters:parameters error:&e] mutableCopy];
    if (e) {
        if (error) {
#if RFDEBUG
            NSString *errorMessage = [NSString stringWithFormat:@"无法序列化参数\n请检查代码是否正确"];
            dout_error(@"%@", errorMessage);
#endif
            *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:@{
                NSLocalizedDescriptionKey : @"内部错误，无法创建请求",
                NSLocalizedFailureReasonErrorKey : @"很可能是应用bug",
                NSLocalizedRecoverySuggestionErrorKey : @"请再试一次，如果依旧请尝试重启应用。给您带来不便，敬请谅解",
                NSURLErrorFailingURLErrorKey : URLString
            }];
        }
        return nil;
    }
    
    [headers enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL *__unused stop) {
        [request setValue:value forHTTPHeaderField:field];
    }];

	return request;
}

@end

#import "UIImageView+AFNetworking.h"

@implementation UIImageView (API)

- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage requestFailedImage:(UIImage *)requestFailedImage {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APIURLAssetsBase, urlString]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];

    @weakify(self);
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        @strongify(self);
        if (requestFailedImage) {
            self.image = requestFailedImage;
        }
    }];
}

- (void)setImageWithURLString:(NSString *)urlString {
    [self setImageWithURLString:urlString placeholderImage:[UIImage imageNamed:@"blank"] requestFailedImage:[UIImage imageNamed:@"blank"]];
}

@end
