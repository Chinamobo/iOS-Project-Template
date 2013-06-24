
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
    
    op.credential = self.defaultCredential;
#ifdef _AFNETWORKING_PIN_SSL_CERTIFICATES_
    op.SSLPinningMode = self.defaultSSLPinningMode;
#endif
    op.allowsInvalidSSLCertificate = self.allowsInvalidSSLCertificate;
    
    [self enqueueHTTPRequestOperation:op];
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
    
    op.credential = self.defaultCredential;
#ifdef _AFNETWORKING_PIN_SSL_CERTIFICATES_
    op.SSLPinningMode = self.defaultSSLPinningMode;
#endif
    op.allowsInvalidSSLCertificate = self.allowsInvalidSSLCertificate;
    
    [self enqueueHTTPRequestOperation:op];
}

@end
