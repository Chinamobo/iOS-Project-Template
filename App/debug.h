
#ifndef App_debug_h
#define App_debug_h

#define DOUT_ASSERT_AT_ERROR 0
#define DOUT_TREAT_ERROR_AS_EXCEPTION 0

#define DOUT_ASSERT_AT_WANRNING 0
#define DOUT_TREAT_WANRNING_AS_EXCEPTION 0

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

#endif
