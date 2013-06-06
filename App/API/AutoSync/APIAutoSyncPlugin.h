/**
    APIAutoSyncPlugin
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

#import "RFPlugin.h"

typedef NS_OPTIONS(NSUInteger, APIAutoSyncPluginStatus) {

    APIAutoSyncPluginStatusNone = 0,
    
    // 当 API 同步条件满足时该位置为1
    APIAutoSyncPluginStatusMasterConditionMatched = 1 << 0,
    
    // 当更新时间周期满足时该位置为1
    APIAutoSyncPluginStatusTimeIntervalMatched = 1 << 1,
    
    // 已经完成过更新时该位置为1
    APIAutoSyncPluginStatusFinished = 1 << 4
};

@protocol APIAutoSyncPluginDelegate;

@interface APIAutoSyncPlugin : RFPlugin

- (id)initWithMaster:(id<APIAutoSyncPluginDelegate>)api;

// 更新检查间隔
@property (assign, nonatomic) NSTimeInterval syncCheckInterval;
@property (copy, nonatomic) NSDate *lastSyncCheckTime;

@property (assign, nonatomic) APIAutoSyncPluginStatus staues;

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
