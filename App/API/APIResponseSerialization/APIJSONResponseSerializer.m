
#import "APIJSONResponseSerializer.h"
#import "RFKit.h"

extern NSString *const APIErrorDomain;

@interface APIJSONResponseSerializer ()

@end

@implementation APIJSONResponseSerializer

+ (instancetype)sharedInstance {
	static APIJSONResponseSerializer *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
	return sharedInstance;
}

+ (instancetype)serializer {
    APIJSONResponseSerializer *serializer = [[self alloc] init];
    return serializer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.readingOptions = 0;
        self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];

        // 如果想让请求接受更多种 HTTP 状态
//        self.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
    }
    return self;
}

// NSHTTPURLResponse 的验证，在此验证 header 和 status code 比较好
// responseObjectForResponse:data:error: 做其它验证
- (BOOL)validateResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
    if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
        // 这种情形似乎是普通的 NSURLResponse
        return YES;
    }

    // HTTP status code 检查
    if (self.acceptableStatusCodes && ![self.acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode]) {
        if (self.serverReportErrorUsingStatusCode && response.statusCode >= 400 && response.statusCode < 500) {
            // 服务器通过 status code 报错
        }
        else {
            if (error) {
#if RFDEBUG
                NSString *errorMessage = [NSString stringWithFormat:@"请求状态异常：%@ (%ld)\n\
HTTP 状态与 ResponseSerializer 的 acceptableStatusCodes 预期不符合\n\
如果服务器通过 HTTP 状态报错，请增加 acceptableStatusCodes 的设置", [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode], (long)response.statusCode];
                dout_error(@"%@", errorMessage);
#endif

                *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:@{
                    NSLocalizedDescriptionKey : [NSString stringWithFormat:@"请求状态异常：%@ (%ld)", [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode], (long)response.statusCode],
                    NSLocalizedFailureReasonErrorKey : @"可能服务器正在升级或者维护，也可能是应用bug",
                    NSLocalizedRecoverySuggestionErrorKey : @"建议稍后重试，如果持续报告这个错误请检查应用是否有新版本",
                    NSURLErrorFailingURLErrorKey : response.URL
                }];
            }
            return NO;
        }
    }

    // HTTP Content-Type 检查
    if (self.acceptableContentTypes && ![self.acceptableContentTypes containsObject:response.MIMEType]) {
        if (error) {
#if RFDEBUG
            NSString *errorMessage = [NSString stringWithFormat:@"服务器返回的 Content-Type 是 %@，而可以接受的是 %@\n请联系后台人员，把 JSON 返回的 Content-Type 改成标准的 application/json", response.MIMEType, self.acceptableContentTypes];
            dout_error(@"%@", errorMessage);
#endif
            *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:@{
                NSLocalizedDescriptionKey : @"服务器返回的类型与预期不符合",
                NSLocalizedFailureReasonErrorKey : @"可能服务器正在升级或者维护，也可能是应用bug",
                NSLocalizedRecoverySuggestionErrorKey : @"建议稍后重试，如果持续报告这个错误请检查应用是否有新版本",
                NSURLErrorFailingURLErrorKey : response.URL
            }];
        }
        return NO;
    }

    // 非空检查
    if (!data.length) {
        if (error) {
#if RFDEBUG
            NSString *errorMessage = [NSString stringWithFormat:@"空内容不被视为正常返回\n请联系后台人员确认状况"];
            dout_error(@"%@", errorMessage);
#endif
            *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorZeroByteResource userInfo:@{
                NSLocalizedDescriptionKey : @"服务器返回空的内容",
                NSLocalizedFailureReasonErrorKey : @"可能服务器正在升级或者维护，也可能是应用bug",
                NSLocalizedRecoverySuggestionErrorKey : @"建议稍后重试，如果持续报告这个错误请检查应用是否有新版本",
                NSURLErrorFailingURLErrorKey : response.URL
            }];
        }
        return NO;
    }

    return YES;
}

#pragma mark - AFURLRequestSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {

    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if ([(NSError *)(*error) code] == NSURLErrorCannotDecodeContentData) {
            return nil;
        }
    }

    NSString *responseString = [[NSString alloc] initWithData:data encoding:self.stringEncoding];
    if (!responseString.length) {
        if (error) {
#if RFDEBUG
            NSString *errorMessage = [NSString stringWithFormat:@"因编码问题不能处理响应数据\n建议先验证返回是否是合法的JSON，并联系后台人员"];
            dout_error(@"%@", errorMessage);
#endif
            *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:@{
                NSLocalizedDescriptionKey : @"无法处理服务器的返回",
                NSLocalizedFailureReasonErrorKey : @"可能服务器正在升级或者维护，也可能是应用bug",
                NSLocalizedRecoverySuggestionErrorKey : @"建议稍后重试，如果持续报告这个错误请检查应用是否有新版本",
                NSURLErrorFailingURLErrorKey : response.URL
            }];
        }
        return nil;
    }

    NSError __autoreleasing *e = nil;
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];

    // 检查能否解析
    if (e) {
        if (error) {
#if RFDEBUG
            NSString *errorMessage = [NSString stringWithFormat:@"解析器返回的错误信息：%@\n建议先验证返回是否是合法的JSON，并联系后台人员", e.localizedDescription];
            dout_error(@"%@", errorMessage);
#endif
            *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotParseResponse userInfo:@{
                NSLocalizedDescriptionKey : @"无法解析返回数据",
                NSLocalizedFailureReasonErrorKey : @"可能服务器正在升级或者维护，也可能是应用bug",
                NSLocalizedRecoverySuggestionErrorKey : @"建议稍后重试，如果持续报告这个错误请检查应用是否有新版本",
                NSURLErrorFailingURLErrorKey : response.URL
            }];
        }
        return nil;
    }

    // 检查是否是错误信息
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        APIJSONError *APIError = [[APIJSONError alloc] initWithDictionary:responseObject error:nil];
        if (APIError) {
            if (error) {
#if RFDEBUG
                NSString *errorMessage = [NSString stringWithFormat:@"服务器返回的错误信息：%@\n", [APIError localizedDescription]];
                dout_error(@"%@", errorMessage);
#endif
                *error = [NSError errorWithDomain:APIErrorDomain code:APIError.errorCode userInfo:@{
                    NSLocalizedDescriptionKey : APIError.errorDescription,
                    NSURLErrorFailingURLErrorKey : response.URL
                }];
            }
            return nil;
        }
    }

    return responseObject;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }

    self.readingOptions = [decoder decodeIntegerForKey:@keypathClassInstance(APIJSONResponseSerializer, readingOptions)];
    self.serverReportErrorUsingStatusCode = [decoder decodeBoolForKey:@keypathClassInstance(APIJSONResponseSerializer, serverReportErrorUsingStatusCode)];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

    [coder encodeInteger:self.readingOptions forKey:@keypathClassInstance(APIJSONResponseSerializer, readingOptions)];
    [coder encodeBool:self.serverReportErrorUsingStatusCode forKey:@keypathClassInstance(APIJSONResponseSerializer, serverReportErrorUsingStatusCode)];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFJSONResponseSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.readingOptions = self.readingOptions;
    
    return serializer;
}

#pragma mark - Tool

@end


@implementation APIJSONError

+ (JSONKeyMapper *)keyMapper {
    APIJSONError *this;
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                @"error": @keypath(this, errorDescription),
                @"code": @keypath(this, errorCode)
            }];
}

+ (NSString *)localizedDescriptionKeyForErrorCode:(int)errorCode {
    return nil;
}

- (NSString *)localizedDescription {
    NSString *description = [APIJSONError localizedDescriptionKeyForErrorCode:self.errorCode];
    if (!description) {
        description = self.errorDescription;
    }

    if (!description) {
        description = @"";
    }
    return description;
}

@end

