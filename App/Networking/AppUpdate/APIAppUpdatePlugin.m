
#import "APIAppUpdatePlugin.h"
#import "API.h"

NSString *const UDkUpdateIgnoredVersion = @"Update Ignored Version";
NSString *const UDkUpdateInfomation     = @"Update Infomation";

@interface APIAppUpdatePlugin () <
    UIAlertViewDelegate
>
@property (weak, nonatomic) API *master;
@property (assign, nonatomic) BOOL silenceMode;
@property (readwrite, nonatomic) BOOL needsForceUpdate;
@property (readwrite, nonatomic) BOOL hasNewVersion;
@property (readwrite, nonatomic) BOOL versionIgnored;
@property (copy, nonatomic) void (^complationBlock)(APIAppUpdatePlugin *);
@end

// 只是用于hold住插件，防止在AlertView dismiss前被释放
@interface APIAppUpdatePluginAlertView : UIAlertView
@property (strong, nonatomic) APIAppUpdatePlugin *plugin;
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
        [self onInit];
        [self performSelector:@selector(afterInit) withObject:self afterDelay:0];
    }
    return self;
}

- (void)onInit {
    [super onInit];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    NSString *json = [ud objectForKey:UDkUpdateInfomation];
    id __autoreleasing e = nil;
    self.versionInfo = [[MBAppVersion alloc] initWithString:json error:&e];
    if (e) dout_error(@"%@", e);
    [self onVersionInfoUpdated];
}

- (MBAppVersion *)versionInfo {
    if (!_versionInfo) {
        _versionInfo = [MBAppVersion new];
    }
    return _versionInfo;
}

- (void)checkUpdateSilence:(BOOL)isSilence completion:(void (^)(APIAppUpdatePlugin *))completion {
    if (self.checking) {
        if (!isSilence) {
            [UIAlertView showWithTitle:@"更新提示" message:@"正在检查更新，请稍后再试" buttonTitle:@"知道了"];
        }
        return;
    }

    self.checking = YES;
    self.silenceMode = isSilence;
    self.complationBlock = completion? completion : ^(APIAppUpdatePlugin *plugin) {};

    AFHTTPRequestOperation *op;
    @weakify(self);
    void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        dout_warning(@"检查版本出错 %@", error);
        self.checking = NO;
        self.lastError = error;
        self.complationBlock(self);
    };
    switch (self.checkSource) {
        case APIAppUpdatePluginCheckSourceAppStore: {
            NSURLRequest *rq = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@", [NSBundle mainBundle].bundleIdentifier]]];

            op = [[AFHTTPRequestOperation alloc] initWithRequest:rq];
            op.responseSerializer = [AFJSONResponseSerializer serializer];
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
                @strongify(self);
                NSDictionary *itemInfo = [(NSArray *)JSON[@"results"] firstObject];
                if (itemInfo) {
                    self.versionInfo.releaseNote = itemInfo[@"releaseNotes"];
                    self.versionInfo.version = itemInfo[@"version"];
                    self.versionInfo.URI = itemInfo[@"trackViewUrl"];
                }
                [self onVersionInfoUpdated];
            } failure:failureBlock];

            [self.master addOperation:op];
            return;
        }

        case APIAppUpdatePluginCheckSourceEnterpriseDistributionPlist: {
            op = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:self.enterpriseDistributionPlistURL]];
            op.responseSerializer = [AFPropertyListResponseSerializer serializer];
            [op.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/x-plist", @"text/xml", nil]];
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id plist) {
                @strongify(self);
                NSDictionary *itemInfo = [[(NSArray *)plist[@"items"] firstObject] valueForKey:@"metadata"];
                if (itemInfo) {
                    self.versionInfo.version = itemInfo[@"bundle-version"];
                    self.versionInfo.releaseNote = itemInfo[@"releaseNotes"];
                    self.versionInfo.URI = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", self.enterpriseDistributionPlistURL];
                }
                [self onVersionInfoUpdated];
            } failure:failureBlock];

            [self.master addOperation:op];
            return;
        }

        case APIAppUpdatePluginCheckSourceCustomAPI: {
            [self checkCustomAPI];
            return;
        }

        default:
            dout_warning(@"Unimplemented APIAppUpdatePluginCheckSource type.");
            self.checking = NO;
            break;
    }
}

- (void)checkCustomAPI {
    RFAPIControl *cn = [RFAPIControl new];

    @weakify(self);
    [self.master requestWithName:APINameCheckUpdate parameters:nil controlInfo:cn success:^(AFHTTPRequestOperation *operation, MBAppVersion *responseObject) {
        @strongify(self);
        self.versionInfo = responseObject;
        [self onVersionInfoUpdated];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        self.lastError = error;

        if (!self.silenceMode) {
            [self.master.networkActivityIndicatorManager alertError:error title:@"更新检查失败"];
        }
    } completion:^(AFHTTPRequestOperation *operation) {
        @strongify(self);
        self.checking = NO;
        self.complationBlock(self);
    }];
}

- (void)onVersionInfoUpdated {
    NSString *remoteVersion = self.versionInfo.version;
    NSString *appVersion = [[NSBundle mainBundle] versionString];
    NSString *requiredVersion = self.versionInfo.minimalRequiredVersion;

    self.versionIgnored = ([remoteVersion isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:UDkUpdateIgnoredVersion]]);
    
    self.hasNewVersion = ([appVersion compare:remoteVersion options:NSNumericSearch] == NSOrderedAscending);
    if (requiredVersion.length) {
        self.needsForceUpdate = ([appVersion compare:requiredVersion options:NSNumericSearch] == NSOrderedAscending);
    }

    if (self.needsForceUpdate) {
        APIAppUpdatePluginAlertView *notice = [[APIAppUpdatePluginAlertView alloc] initWithTitle:@"强制更新提示" message:[NSString stringWithFormat:@"应用必须更新才能使用\n%@\n点击确认关闭应用", self.versionInfo.releaseNote] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        notice.plugin = self;
        [notice show];
    }
    else if (self.versionIgnored) {
        dout_info(@"被忽略的版本")
    }
    else if (self.hasNewVersion && self.checking) {
        APIAppUpdatePluginAlertView *notice = [[APIAppUpdatePluginAlertView alloc] initWithTitle:[NSString stringWithFormat:@"新版本(%@)可用", remoteVersion] message:self.versionInfo.releaseNote delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"更新", self.allowUserIgnoreNewVersion? @"跳过该版本" : nil, nil];
        notice.plugin = self;
        [notice show];
    }
    else {
        // 没有新版本
        if (!self.silenceMode && self.checking) {
            UIAlertView *notice = [[UIAlertView alloc] initWithTitle:@"没有新版本" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [notice show];
        }
    }

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[self.versionInfo toJSONString] forKey:UDkUpdateInfomation];
    [ud synchronize];

    self.checking = NO;
    self.complationBlock(self);
}

- (void)ignoreCurrentVersion {
    [[NSUserDefaults standardUserDefaults] setObject:self.versionInfo.version forKey:UDkUpdateIgnoredVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSURL *url = [NSURL URLWithString:self.versionInfo.URI];
    RFAssert(url, @"nil install url?");

    switch (buttonIndex) {
        case 0:
            // 取消
            if (self.needsForceUpdate) {
                [[UIApplication sharedApplication] openURL:url];
                exit(EXIT_SUCCESS);
            }
            break;
            
        case 1:
            // 更新
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            else {
                dout_warning(@"Can`t open update url: %@", url);
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
