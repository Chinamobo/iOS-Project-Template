
#import "JPushManager.h"
#import "APIInterface.h"

@interface JPushManager ()
@property (strong, nonatomic) id networkDidReceiveMessageObserver;
@end

@implementation JPushManager
RFInitializingRootForNSObject

+ (instancetype)sharedInstance {
	static JPushManager *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
	return sharedInstance;
}

+ (JPushManager *)setupWithApplicationLaunchOptions:(NSDictionary *)launchOptions {
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    [APService setupWithOption:launchOptions];

    JPushManager *s = [JPushManager sharedInstance];
    NSDictionary *remoteNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        [s didReceiveRemoteNotification:remoteNotification];
    }

	return s;
}

- (void)onInit {
    // Mark: 也许不用清空，看情况
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    self.networkDidReceiveMessageObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kAPNetworkDidReceiveMessageNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self didReceiveRemoteNotification:note.userInfo];
    }];
}

- (void)afterInit {
}

- (void)didReceiveRemoteNotification:(NSDictionary *)notification {
    dout(@"收到推送信息：%@", notification);

    // TODO: 收到推送的操作
}

+ (void)setAlias:(NSString *)alias {
    JPushManager *s = [JPushManager sharedInstance];

    [APService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:s];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.networkDidReceiveMessageObserver];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    if (iResCode > 6000) {
        // 具体错误码见： http://docs.jpush.cn/pages/viewpage.action?pageId=3309913
        dout_error(@"JPush Alias 设置失败");
    }
    dout_info(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

@end
