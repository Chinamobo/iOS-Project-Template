
#import "AFNetworking.h"

@interface AFHTTPClient (API)

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(AFJSONRequestOperation *operation, id JSONObject, NSError *error))callback;

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(AFJSONRequestOperation *operation, id JSONObject, NSError *error))callback;

@end
