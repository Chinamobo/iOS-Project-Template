
#ifndef App_debug_h
#define App_debug_h

// 在界面中显示异常信息
// 在交给非开发人员的测试版本中使用会比较有用，不要在发布版本中使用
#ifndef DebugEnableUncaughtExceptionHandler
    #define DebugEnableUncaughtExceptionHandler 0
#endif

/// API
// 每次启动强制自动更新，忽略更新间隔检查
#define DebugAPIUpdateForceAutoUpdate 0

// 使用本地测试数据，而不是网上获取
#define DebugAPIUsingLocalTestData 0

// 测试帐户
#define DebugAPIEnableTestProfile 0
#define DebugAPITestProfileName @"name"
#define DebugAPITestProfilePassword @"pass"
#define DebugAPITestProfileMacAddress @"something"

/// Data model
// 当 Core Data 数据模型修改时重置数据库
// 一定不要在有发布版后使用，要建版本去merge
#define DebugResetPersistentStoreIfCannotAutomaticallyMigrated 1

#endif
