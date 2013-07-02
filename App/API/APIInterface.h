/**
    APIInterface

    接口定义与 API 模块配置
    注意与调试相关的开关要定义在 debug.h 中

    其他模块不应直接访问这里
    需要对外的在 API.h 中用 extern 导出
 */

#import <Foundation/Foundation.h>

#pragma mark - 接口定义
NSString *const APIURLDeployBase    = @"http://example.com/api/";

NSString *const APIURLExample       = @"exapmle";

// 用户接口
NSString *const APIURLLogin         = @"login";
NSString *const APIURLForgetPassword= @"forgetPassword";
NSString *const APIURLUserInfo      = @"userInfo";

#pragma mark - User deafult key


#pragma mark - 配置
BOOL const APIConfigOfflineLoginEnabled = NO;

#pragma mark APIAppUpdatePlugin
NSUInteger APIConfigFetchPageSize = 10;

NSString *const APIConfigAppStroeID = nil;
NSString *const APIConfigEnterpriseDistributionURL = @"";

#pragma mark APIAutoSyncPlugin
NSTimeInterval const APIConfigAutoUpdateCheckInterval = 5000;
