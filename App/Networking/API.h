/*!
    API

    Copyright © 2013-2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFAPI.h"
#import "RFMessageManager+RFDisplay.h"
#import "DataStack.h"
#import "APIInterface.h"
#import "AFHTTPRequestOperation.h"

#import "APIUserPlugin.h"
#import "APIAutoSyncPlugin.h"
#import "APIAppUpdatePlugin.h"

/**
 API
 网络基础及接口封装

 如果有像UserID这种东西，让API来管理，不要在外面获取再传进来
 */
@interface API : RFAPI

/**

 @param APIName 接口名，同时会作为请求的 identifier
 @param viewController 请求所属视图，会取到它的 class 名作为请求的 groupIdentifier
 */
+ (AFHTTPRequestOperation *)requestWithName:(NSString *)APIName parameters:(NSDictionary *)parameters viewController:(UIViewController *)viewController loadingMessage:(NSString *)message modal:(BOOL)modal success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success completion:(void (^)(AFHTTPRequestOperation *operation))completion;

/**
 显示一个操作成功的信息，显示一段时间后自动隐藏
 */
+ (void)showSuccessStatus:(NSString *)message;

/**
 取消属于 viewController 的请求，这些请求必须用 viewController 的类名做为 groupIdentifier
 */
+ (void)cancelOperationsWithViewController:(id)viewController;

#pragma mark - 具体业务



#pragma mark - 插件

+ (APIUserPlugin *)user;

@property (strong, nonatomic) APIUserPlugin *user;
@property (strong, nonatomic) APIAppUpdatePlugin *appUpdatePlugin;

@end

extern NSUInteger APIConfigFetchPageSize;

@interface UIImageView (App)

- (void)setImageWithURLString:(NSString *)path placeholderImage:(UIImage *)placeholder;

/**
 @param path 图片的 URL 地址，如果是相对地址，会跟 APIURLAssetsBase 做拼接
 @param placeholderImage 占位图，若为空，会把当前图片作为占位符
 */
- (void)setImageWithURLString:(NSString *)path placeholderImage:(UIImage *)placeholderImage completion:(void (^)(void))completion;

@end

