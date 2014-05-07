
#import "APIAppUpdatePlugin.h"
#import "AFHTTPRequestOperationManager.h"
#import "API.h"

NSString *const UDkUpdateIgnoredVersion = @"Update Ignored Version";
NSString *const UDkUpdateForceVesrion   = @"Update Force Version";
NSString *const UDkUpdateInstallURI     = @"Update Inatall URI";

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
        [self onInit];
        [self performSelector:@selector(afterInit) withObject:self afterDelay:0];
    }
    return self;
}

- (void)onInit {
    [super onInit];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.versionInfo.minimalRequiredVersion = [ud objectForKey:UDkUpdateForceVesrion];
    self.versionInfo.URI = [ud objectForKey:UDkUpdateInstallURI];
}

- (MBAppVersion *)versionInfo {
    if (!_versionInfo) {
        _versionInfo = [MBAppVersion new];
    }
    return _versionInfo;
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

    AFHTTPRequestOperation *op;
    @weakify(self);
    void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        dout_warning(@"检查版本出错 %@", error);
        self.isChecking = NO;
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
                NSDictionary *itemInfo = [(NSArray *)plist[@"items"] firstObject];
                if (itemInfo) {
                    NSDictionary *metaData = itemInfo[@"metadata"];
                    self.versionInfo.version = metaData[@"bundle-version"];
                    self.versionInfo.releaseNote = metaData[@"releaseNotes"];
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
            self.isChecking = NO;
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
        self.isChecking = NO;
        self.complationBlock(self);
    }];
}

- (void)onVersionInfoUpdated {
    NSString *version = self.versionInfo.version;
    NSString *currentVersion = [[NSBundle mainBundle] versionString];
    NSString *minimalRequiredVersion = self.versionInfo.minimalRequiredVersion;

    BOOL isIgnored = ([version isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:UDkUpdateIgnoredVersion]]);
    
    BOOL hasNewVersion = ([currentVersion compare:version options:NSNumericSearch] == NSOrderedAscending);
    if (minimalRequiredVersion.length) {
        self.needsForceUpdate = ([currentVersion compare:minimalRequiredVersion options:NSNumericSearch] == NSOrderedAscending);
    }

    if (self.needsForceUpdate) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:minimalRequiredVersion forKey:UDkUpdateForceVesrion];
        [ud setObject:self.versionInfo.URI forKey:UDkUpdateInstallURI];
        [ud synchronize];

        APIAppUpdatePluginAlertView *notice = [[APIAppUpdatePluginAlertView alloc] initWithTitle:@"强制更新提示" message:[NSString stringWithFormat:@"应用必须更新才能使用\n%@\n点击确认关闭应用", self.versionInfo.releaseNote] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        notice.plugin = self;
        [notice show];
    }
    else if (isIgnored) {
        dout_info(@"被忽略的版本")
    }
    else if (hasNewVersion) {
        APIAppUpdatePluginAlertView *notice = [[APIAppUpdatePluginAlertView alloc] initWithTitle:[NSString stringWithFormat:@"新版本(%@)可用", version] message:self.versionInfo.releaseNote delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"更新", @"跳过该版本", nil];
        notice.plugin = self;
        [notice show];
    }
    else {
        // 没有新版本
        if (!self.silenceMode) {
            UIAlertView *notice = [[UIAlertView alloc] initWithTitle:@"没有新版本" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [notice show];
        }
    }
    self.isChecking = NO;
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
