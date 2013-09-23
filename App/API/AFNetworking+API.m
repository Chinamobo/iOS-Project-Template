
#import "AFNetworking+API.h"
#import "debug.h"

@interface AFHTTPClient ()
@property (readwrite, nonatomic, strong) NSURLCredential *defaultCredential;
@end

@implementation AFHTTPClient (API)

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(AFJSONRequestOperation *operation, id JSONObject, NSError *error))callback {
    AFJSONRequestOperation *op;
    op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:path parameters:parameters] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        dispatch_after_seconds(DebugAPIDeplayFetchCallbackReturnSecond, ^{
            callback(op, JSON, nil);
        });
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        callback(op, JSON, error);
    }];
    
    [self enqueueJSONRequestOperation:op];
}

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(AFJSONRequestOperation *operation, id JSONObject, NSError *error))callback {
    AFJSONRequestOperation *op;
    op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"POST" path:path parameters:parameters] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        dispatch_after_seconds(DebugAPIDeplayFetchCallbackReturnSecond, ^{
            callback(op, JSON, nil);
        });
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        callback(op, JSON, error);
    }];
    
    [self enqueueJSONRequestOperation:op];
}

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters attachFiles:(void (^)(id <AFMultipartFormData> formData))bodyConstructBlock uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock completion:(void (^)(AFJSONRequestOperation *operation, id JSONObject, NSError *error))callback {
    NSMutableURLRequest *rq = [self multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock:bodyConstructBlock];
    
    AFJSONRequestOperation *op = [[AFJSONRequestOperation alloc] initWithRequest:rq];
    [op setUploadProgressBlock:progressBlock];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_after_seconds(DebugAPIDeplayFetchCallbackReturnSecond, ^{
            callback((AFJSONRequestOperation *)operation, responseObject, nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback((AFJSONRequestOperation *)operation, nil, error);
    }];
    
    [self enqueueJSONRequestOperation:op];
}

- (void)enqueueJSONRequestOperation:(AFHTTPRequestOperation *)operation {
    operation.credential = self.defaultCredential;
#ifdef _AFNETWORKING_PIN_SSL_CERTIFICATES_
    operation.SSLPinningMode = self.defaultSSLPinningMode;
#endif
    operation.allowsInvalidSSLCertificate = self.allowsInvalidSSLCertificate;
    
    [self enqueueHTTPRequestOperation:operation];
}

@end
