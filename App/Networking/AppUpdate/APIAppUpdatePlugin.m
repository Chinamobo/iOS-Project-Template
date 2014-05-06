
#import "APIAppUpdatePlugin.h"
#import "AFHTTPRequestOperationManager.h"
#import "API.h"

NSString *const UDkUpdateIgnoredVersion = @"Update Ignored Version";
NSString *const UDkUpdateForceVesrion = @"Update Force Version";

@interface APIAppUpdatePlugin () <
    UIAlertViewDelegate
>
@property (weak, nonatomic) API *master;
@property (assign, nonatomic) BOOL silenceMode;
@property (copy, nonatomic) void (^complationBlock)(APIAppUpdatePlugin *);
@end

@implementation APIAppUpdatePlugin

- (instancetype)init {
    RFAssert(false, @"Use initWithMaster: instead.");
    return nil;
}

- (instancetype)initWithMaster:(API *)api {
    self = [super init];
    if (self) {
        self.master = api;
        
        self.noticeDelegate = self;
    }
    return self;
}

- (void)checkUpdateSilence:(BOOL)isSilence completion:(void (^)(APIAppUpdatePlugin *))completion {
    if (self.isChecking) {
        if (!isSilence) {
            [UIAlertView showWithTitle:@"更新提示" message:@"正在检查更新，请稍后再试" buttonTitle:@"知道了"];
        }
        return;
    }

    self.isChecking = YES;
    self.silenceMode = isSilence;
    self.complationBlock = completion? completion : ^(APIAppUpdatePlugin *plugin) {};

    if (self.customCheckAPIURL) {
        [self checkCustomAPI];
        return;
    }

    AFHTTPRequestOperation *op;
    
    if (self.appStoreID) {
        NSURLRequest *rq = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", self.appStoreID]]];
        
        op = [[AFHTTPRequestOperation alloc] initWithRequest:rq];
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
            [self proccessAppStoreInfo:JSON];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            id JSON = operation.responseObject;
            if ([JSON isKindOfClass:[NSDictionary class]]) {
                [self proccessAppStoreInfo:JSON];
            }
            else {
                dout_warning(@"检查版本出错 %@", error);
                self.isChecking = NO;
                self.lastError = error;
                self.complationBlock(self);
            }
        }];
        
        [self.master addOperation:op];
        return;
    }
    
    if (self.enterpriseDistributionPlistURL) {
        op = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:self.enterpriseDistributionPlistURL]];
        op.responseSerializer = [AFPropertyListResponseSerializer serializer];
        [op.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/x-plist", @"text/xml", nil]];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id plist) {
            [self proccessEnterpriseDistributionInfo:plist];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dout_warning(@"检查版本出错 %@", error);
            self.isChecking = NO;
            self.lastError = error;
            self.complationBlock(self);
        }];
        
        [self.master addOperation:op];
        return;
    }

    dout_error(@"Can't check updated version. Neither appStoreID or enterpriseDistributionPlistURL set.");
    self.isChecking = NO;
}

- (void)checkCustomAPI {

}

- (void)proccessAppStoreInfo:(NSDictionary *)info {
    NSDictionary *itemInfo = [(NSArray *)info[@"results"] firstObject];
    if (!itemInfo) return;
    
    self.releaseNotes = itemInfo[@"releaseNotes"];
    self.remoteVersion = itemInfo[@"version"];
    self.installURL = [NSURL URLWithString: itemInfo[@"trackViewUrl"]];
    
    [self checkResponseInfo];
}

- (void)proccessEnterpriseDistributionInfo:(NSDictionary *)info {
    NSDictionary *itemInfo = [(NSArray *)info[@"items"] firstObject];
    if (!itemInfo) return;
    
    self.installURL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", self.enterpriseDistributionPlistURL]];
    
    NSDictionary *metaData = itemInfo[@"metadata"];
    self.remoteVersion = metaData[@"bundle-version"];
    self.releaseNotes = metaData[@"releaseNotes"];
    
    [self checkResponseInfo];
}

- (void)checkResponseInfo {
    BOOL isIgnored = ([self.remoteVersion isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:UDkUpdateIgnoredVersion]]);
    
    NSString *currentVersion = [[NSBundle mainBundle] versionString];
    BOOL hasNewVersion = ([currentVersion compare:self.remoteVersion options:NSNumericSearch] == NSOrderedAscending);

    if (hasNewVersion && self.isForceUpdate) {
        [[NSUserDefaults standardUserDefaults] setObject:self.remoteVersion forKey:UDkUpdateForceVesrion];
        [[NSUserDefaults standardUserDefaults] synchronize];

        APIAppUpdatePluginAlertView *notice = [[APIAppUpdatePluginAlertView alloc] initWithTitle:@"强制更新提示" message:[NSString stringWithFormat:@"应用必须更新才能使用\n%@\n点击确认关闭应用", self.releaseNotes] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        notice.plugin = self;
        [notice show];
        self.isChecking = NO;
        self.complationBlock(self);
        return;
    }

    if ([self.noticeDelegate respondsToSelector:@selector(appUpdatePlugin:hasNewVersionAvailable:isIgnored:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.noticeDelegate appUpdatePlugin:self hasNewVersionAvailable:hasNewVersion isIgnored:isIgnored];
            self.isChecking = NO;
            self.complationBlock(self);
        });
    }
}

- (void)appUpdatePlugin:(APIAppUpdatePlugin *)plugin hasNewVersionAvailable:(BOOL)hasNewVersion isIgnored:(BOOL)isIgnored {
    if (isIgnored) {
        dout_info(@"被忽略的版本")
        return;
    }
    
    if (hasNewVersion) {
        APIAppUpdatePluginAlertView *notice = [[APIAppUpdatePluginAlertView alloc] initWithTitle:[NSString stringWithFormat:@"新版本(%@)可用", plugin.remoteVersion] message:plugin.releaseNotes delegate:plugin cancelButtonTitle:@"下次再说" otherButtonTitles:@"更新", @"跳过该版本", nil];
        notice.plugin = self;
        [notice show];
    }
    else if (self.showNoticeIfNoUpdateAvailableUsingBuildInNoticeDelegate) {
        UIAlertView *notice = [[UIAlertView alloc] initWithTitle:@"没有新版本" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [notice show];
    }
}

- (void)ignoreCurrentVersion {
    [[NSUserDefaults standardUserDefaults] setObject:self.remoteVersion forKey:UDkUpdateIgnoredVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            // 取消
            if (self.isForceUpdate) {
                [[UIApplication sharedApplication] openURL:self.installURL];
                exit(EXIT_SUCCESS);
            }
            break;
            
        case 1:
            // 更新
            if ([[UIApplication sharedApplication] canOpenURL:self.installURL]) {
                [[UIApplication sharedApplication] openURL:self.installURL];
            }
            else {
                dout_warning(@"Can`t open update url: %@", self.installURL);
            }
            break;
            
        case 2:
            [self ignoreCurrentVersion];
            break;
            
        default:
            break;
    }
}

@end

@implementation APIAppUpdatePluginAlertView
@end
