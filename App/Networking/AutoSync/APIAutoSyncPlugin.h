/*!
    APIAutoSyncPlugin

    Copyright © 2013-2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFPlugin.h"

@protocol APIAutoSyncPluginDelegate;

/**
 API 自动同步插件

 特性：
 * 同步间隔检查，设置syncCheckInterval属性以激活。只在距上次更新时间大于syncCheckInterval后才开始更新
 * 如果未到下次更新时间，会自动设置相应timer，到时间时再执行同步

 使用：
 * API 模块需要创建 canPerformSync 属性，符合更新条件时设为YES，该属性需支持KVO
 * 实现 startSync 用于同步
 * 同步结束后调用 syncFinshed: 方法结束同步，返回NO不会更新同步时间
 * 可以在 clearAfterSync 中释放该插件
 */
@interface APIAutoSyncPlugin : RFPlugin

- (instancetype)initWithMaster:(id<APIAutoSyncPluginDelegate>)api;

// 更新检查间隔
@property (assign, nonatomic) NSTimeInterval syncCheckInterval;
@property (copy, nonatomic) NSDate *lastSyncCheckTime;

// 是否已经同步过了
@property (readonly, nonatomic) BOOL hasSynced;

// API 需要在同步结束后调用该方法已通知插件
- (void)syncFinshed:(BOOL)success;
@end


@protocol APIAutoSyncPluginDelegate <RFPluginSupported>
@required
// 该属性需支持KVO，其值变为YES时将尝试执行自动同步
@property (readonly, assign, nonatomic) BOOL canPerformSync;

- (void)startSync;

@optional
// 在 API 中实现该方法已进行清理
- (void)clearAfterSync;

@end
