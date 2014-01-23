/**
    APIInterface

    接口定义

    其他模块不应直接访问这里
    需要对外的在 API.h 中用 extern 导出
 */

#import <Foundation/Foundation.h>

#pragma mark - 接口定义
NSString *const APIURLDeployBase        = @"http://example.com";

// 资源文件基地址
NSString *const APIURLAssetsBase        = @"http://example.com";

// 用户接口
NSString *const APIURLLogin         = @"login";
NSString *const APIURLForgetPassword= @"forgetPassword";
NSString *const APIURLUserInfo      = @"userInfo";
NSString *const APIURLCheckUpdate       = @"version";

#pragma mark - User deafult key

