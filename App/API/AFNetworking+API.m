
#import "AFNetworking+API.h"
#import "debug.h"

@interface AFHTTPRequestOperationManager ()
@end

@implementation AFHTTPRequestOperationManager (API)

- (AFNetworkReachabilityStatus)networkReachabilityStatus {
    return self.reachabilityManager.networkReachabilityStatus;
}

#pragma mark -

- (AFHTTPRequestOperation *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(void (^)(AFHTTPRequestOperation *operation, id JSONResponseObject, NSError *error))callback {
    AFHTTPRequestOperation *op = [self JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" URLString:URLString parameters:parameters] completion:callback];
    [self.operationQueue addOperation:op];
    return op;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(NSDictionary *)formParameters completion:(void (^)(AFHTTPRequestOperation *operation, id JSONResponseObject, NSError *error))callback {
    AFHTTPRequestOperation *op = [self JSONRequestOperationWithRequest:[self requestWithMethod:@"POST" URLString:URLString parameters:formParameters] completion:callback];
    [self.operationQueue addOperation:op];
    return op;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(NSDictionary *)formParameters attachFiles:(void (^)(id <AFMultipartFormData> formData))bodyConstructBlock completion:(void (^)(AFHTTPRequestOperation *operation, id JSONResponseObject, NSError *error))callback {
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:formParameters constructingBodyWithBlock:bodyConstructBlock];
    AFHTTPRequestOperation *op = [self JSONRequestOperationWithRequest:request completion:callback];
    [self.operationQueue addOperation:op];
    return op;
}

#pragma mark -

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters];
}

- (AFHTTPRequestOperation *)JSONRequestOperationWithRequest:(NSURLRequest *)request completion:(void (^)(AFHTTPRequestOperation *operation, id JSONResponseObject, NSError *error))callback {
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id responseObject) {
        if (DebugAPIDelayFetchCallbackReturnSecond) {
            dispatch_after_seconds(DebugAPIDelayFetchCallbackReturnSecond, ^{
                callback(op, responseObject, nil);
            });
        }
        else {
            callback(op, responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        if (DebugAPIDelayFetchCallbackReturnSecond) {
            dispatch_after_seconds(DebugAPIDelayFetchCallbackReturnSecond, ^{
                callback(op, op.responseObject, error);
            });
        }
        else {
            callback(op, op.responseObject, error);
        }
    }];
    
    return operation;
}


@end
