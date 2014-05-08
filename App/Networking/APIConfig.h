/**
    APIConfig

    API 模块配置
    注意与调试相关的开关要定义在 debug.h 中
*/


/// 用户插件
#pragma mark - APIUserPlugin


/// 自动更新插件
#pragma mark - APIAppUpdatePlugin

NSUInteger APIConfigFetchPageSize = 10;

NSString *const APIConfigAppStroeID = nil;
NSString *const APIConfigEnterpriseDistributionURL = @"https://mobo-app.s3.amazonaws.com/ipas/BoYaSchool.plist";


/// 自动同步插件
#pragma mark - APIAutoSyncPlugin

NSTimeInterval const APIConfigAutoUpdateCheckInterval = 5000;
