

#import "RFPlugin.h"

@class AFHTTPClient, APIAppUpdatePlugin;

@protocol APIAppUpdatePluginNoticeDelegate <NSObject>
@optional
- (void)appUpdatePlugin:(APIAppUpdatePlugin *)plugin  hasNewVersionAvailable:(BOOL)hasNewVersion isIgnored:(BOOL)isIgnored;

@end

@interface APIAppUpdatePlugin : RFPlugin
<APIAppUpdatePluginNoticeDelegate>

- (id)initWithMaster:(AFHTTPClient<RFPluginSupported> *)api;

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

@interface APIAppUpdatePluginAlertView : UIAlertView
@property (strong, nonatomic) APIAppUpdatePlugin *plugin;
@end
