
#import "APIAppUpdatePlugin.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

NSString *const UDkUpdateIgnoredVersion = @"Update Ignored Version";

@interface APIAppUpdatePlugin ()
<APIAppUpdatePluginNoticeDelegate, UIAlertViewDelegate>
@property (RF_WEAK, nonatomic) AFHTTPClient<RFPluginSupported> *master;
@end

@implementation APIAppUpdatePlugin

- (instancetype)init {
    RFAssert(false, @"Use initWithMaster: instead.");
    return nil;
}

- (instancetype)initWithMaster:(AFHTTPClient<RFPluginSupported> *)api {
    self = [super init];
    if (self) {
        self.master = api;
        
        self.noticeDelegate = self;
    }
    return self;
}

- (void)checkUpdate {
    AFHTTPRequestOperation *op;
    
    if (self.appStoreID) {
        NSURLRequest *rq = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", self.appStoreID]]];
        op = [AFJSONRequestOperation JSONRequestOperationWithRequest:rq success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [self proccessAppStoreInfo:JSON];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            if ([JSON isKindOfClass:[NSDictionary class]]) {
                [self proccessAppStoreInfo:JSON];
            }
            else {
                dout_warning(@"检查版本出错 %@", error);
            }
        }];
        [self.master enqueueHTTPRequestOperation:op];
        return;
    }
    
    if (self.enterpriseDistributionPlistURL) {
        op = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:self.enterpriseDistributionPlistURL]];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError __autoreleasing *e = nil;
            id plist = [NSPropertyListSerialization propertyListWithData:responseObject options:0 format:nil error:&e];
            if (e) {
                dout_warning(@"检查版本出错 %@", e);
                return;
            }
            [self proccessEnterpriseDistributionInfo:plist];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dout_warning(@"检查版本出错 %@", error);
        }];
        
        [self.master enqueueHTTPRequestOperation:op];
        return;
    }
    
    dout_error(@"Can't check updated version. Neither appStoreID or enterpriseDistributionPlistURL set.");
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
    
    if ([self.noticeDelegate respondsToSelector:@selector(appUpdatePlugin:hasNewVersionAvailable:isIgnored:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.noticeDelegate appUpdatePlugin:self hasNewVersionAvailable:hasNewVersion isIgnored:isIgnored];
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
