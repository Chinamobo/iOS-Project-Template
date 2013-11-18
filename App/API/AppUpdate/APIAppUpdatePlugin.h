/**
    APIAppUpdatePlugin
    应用更新插件

    特性：
    * 支持 App Store 作为数据源，无需额外服务器
    * 支持企业发布，如需显示更新摘要，需要在`metadata`字段中添加`releaseNotes`字段
    * 用户选择支持直接更新，支持忽略特定版本

    使用：
    * 先设置`appStoreID`或`enterpriseDistributionPlistURL`，同时设置只检查 App Store
    * 执行`checkUpdate`方法进行检查
    * 如果不设置`noticeDelegate`，将使用内建的通知方式通知并提示用户操作
 */

#import "RFPlugin.h"

@class AFHTTPRequestOperationManager, APIAppUpdatePlugin;

@protocol APIAppUpdatePluginNoticeDelegate <NSObject>
@optional
- (void)appUpdatePlugin:(APIAppUpdatePlugin *)plugin  hasNewVersionAvailable:(BOOL)hasNewVersion isIgnored:(BOOL)isIgnored;

@end

@interface APIAppUpdatePlugin : RFPlugin
<APIAppUpdatePluginNoticeDelegate>

- (instancetype)initWithMaster:(AFHTTPRequestOperationManager<RFPluginSupported> *)api;

// AppStore 上的应用ID，如：569781369
@property (copy, nonatomic) NSString *appStoreID;

// 如果同时设置了AppStore ID，则只检查 AppStore 版本
@property (copy, nonatomic) NSURL *enterpriseDistributionPlistURL;

// 执行更新检查
- (void)checkUpdate;

// 更新信息
@property (copy, nonatomic) NSString *releaseNotes;
@property (copy, nonatomic) NSString *remoteVersion;

// 执行安装的URL
@property (copy, nonatomic) NSURL *installURL;

// 可选，不设置使用内建的通知方式
@property (weak, nonatomic) id<APIAppUpdatePluginNoticeDelegate> noticeDelegate;
- (void)ignoreCurrentVersion;

@property (assign, nonatomic) BOOL showNoticeIfNoUpdateAvailableUsingBuildInNoticeDelegate;

@end

extern NSString *const UDkUpdateIgnoredVersion;

// 只是用于hold住插件，防止在AlertView dismiss前被释放
@interface APIAppUpdatePluginAlertView : UIAlertView
@property (strong, nonatomic) APIAppUpdatePlugin *plugin;
@end
