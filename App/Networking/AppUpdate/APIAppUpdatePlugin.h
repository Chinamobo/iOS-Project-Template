/*!
    APIAppUpdatePlugin
    v 1.0

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFPlugin.h"
#import "MBAppVersion.h"

@class API, APIAppUpdatePlugin;

@protocol APIAppUpdatePluginNoticeDelegate <NSObject>
@optional
- (void)appUpdatePlugin:(APIAppUpdatePlugin *)plugin hasNewVersionAvailable:(BOOL)hasNewVersion isIgnored:(BOOL)isIgnored;

@end

/** 
 更新检查源
 
 @const APIAppUpdatePluginCheckSourceAppStore 从商店检查
 @const APIAppUpdatePluginCheckSourceEnterpriseDistributionPlist 企业发布 plist 作为检查源
 @const APIAppUpdatePluginCheckSourceCustomAPI 自定义 API，需要改写 checkCustomAPI 方法
 */
typedef NS_ENUM(short, APIAppUpdatePluginCheckSource) {
    APIAppUpdatePluginCheckSourceAppStore = 0,
    APIAppUpdatePluginCheckSourceEnterpriseDistributionPlist,
    APIAppUpdatePluginCheckSourceCustomAPI
};

/**
 应用更新插件

 特性：
 * 支持 App Store 作为数据源，无需额外服务器，无需额外配置
 * 支持企业发布，如需显示更新摘要，需要在`metadata`字段中添加`releaseNotes`字段
 * 支持自定义检查接口
 * 用户选择支持直接更新，支持忽略特定版本

 使用：
 * 先设置 checkSource 及相应属性
 * 执行`checkUpdate`方法进行检查
 * 使用内建的通知方式通知并提示用户操作
 */
@interface APIAppUpdatePlugin : RFPlugin

- (instancetype)initWithMaster:(API *)api;

#pragma mark - 设置

@property (assign, nonatomic) APIAppUpdatePluginCheckSource checkSource;

/// 如果更新源是企业发布，plist 地址
@property (copy, nonatomic) NSURL *enterpriseDistributionPlistURL;

/// 是否允许用户忽略版本，默认 NO
@property (assign, nonatomic) BOOL allowUserIgnoreNewVersion;

#pragma mark - 检查

/// 执行更新检查
- (void)checkUpdateSilence:(BOOL)isSilence completion:(void (^)(APIAppUpdatePlugin *plugin))completion;

@property (assign, nonatomic) BOOL checking;

#pragma mark 状态信息

@property (strong, nonatomic) MBAppVersion *versionInfo;

@property (copy, nonatomic) NSError *lastError;

/// 是否强制用户升级
@property (readonly, nonatomic) BOOL needsForceUpdate;

/// 有新版本吗
@property (readonly, nonatomic) BOOL hasNewVersion;

/// 新版本是否已忽略
@property (readonly, nonatomic) BOOL versionIgnored;

@end
