/*!
    debug.h
    应用调试开关

    Copyright © 2013-2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#ifndef App_debug_h
#define App_debug_h

/**
 dout() 的行为可在 Build settings 的 Preprocessor Macros 项调节
 */

#pragma mark - 网络调试

/// 如果你想模拟网络延迟，请使用 Network Link Conditioner

/// 每次启动强制自动更新，忽略更新间隔检查
#define DebugAPIUpdateForceAutoUpdate 0


#pragma mark - 用户系统

/// 是否跳过登录
#define DebugAPISkipLogin 0

/// 测试帐户
#define DebugAPIEnableTestProfile 0
#define DebugAPITestProfileName @"name"
#define DebugAPITestProfilePassword @"pass"
#define DebugAPITestProfileMacAddress @"something"


#pragma mark - Core Data

/// 当 Core Data 数据模型修改时重置数据库
/// 一定不要在有发布版后使用，要建版本去merge
#define DebugResetPersistentStoreIfCannotAutomaticallyMigrated 1


#pragma mark - 其他

/// 在界面中显示异常信息
/// 在交给非开发人员的测试版本中使用会比较有用，不要在发布版本中使用
#ifndef DebugEnableUncaughtExceptionHandler
#define DebugEnableUncaughtExceptionHandler 0
#endif

#endif
