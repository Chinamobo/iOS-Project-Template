
#import "APIAutoSyncPlugin.h"
#import "debug.h"

NSString *const UDkLastUpdateCheckTime = @"Last Update Check Time";
static void *const APIAutoSyncPluginKVOContext = (void *)&APIAutoSyncPluginKVOContext;

@interface APIAutoSyncPlugin ()
@property (weak, nonatomic) id<APIAutoSyncPluginDelegate> master;
@property (strong, nonatomic) NSTimer *watchToSyncCheckTimeMatchTimer;
@property (readwrite, nonatomic) BOOL hasSynced;
@end

@implementation APIAutoSyncPlugin

- (instancetype)init {
    RFAssert(false, @"Use initWithMaster: instead.");
    return nil;
}

- (instancetype)initWithMaster:(id<APIAutoSyncPluginDelegate>)api {
    self = [super init];
    if (self) {
        self.master = api;
    }
    return self;
}

- (void)onInit {
    self.lastSyncCheckTime = [[NSUserDefaults standardUserDefaults] objectForKey:UDkLastUpdateCheckTime];
    _dout_float([self.lastSyncCheckTime timeIntervalSinceNow])
}

- (void)afterInit {
    [(NSObject *)self.master addObserver:self forKeyPath:@keypath(self.master, canPerformSync) options:NSKeyValueObservingOptionNew context:APIAutoSyncPluginKVOContext];
    [self addObserver:self forKeyPath:@keypath(self, syncCheckInterval) options:NSKeyValueObservingOptionNew context:APIAutoSyncPluginKVOContext];
    [self evaluateStatus];
}

- (void)dealloc {
    [(NSObject *)self.master removeObserver:self forKeyPath:@keypath(self.master, canPerformSync) context:APIAutoSyncPluginKVOContext];
    [self removeObserver:self forKeyPath:@keypath(self, syncCheckInterval) context:APIAutoSyncPluginKVOContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != APIAutoSyncPluginKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if (object == self.master && [keyPath isEqualToString:@keypath(self.master, canPerformSync)]) {
        [self evaluateStatus];
        return;
    }
    
    if (object == self && [keyPath isEqualToString:@keypath(self, syncCheckInterval)]) {
        [self evaluateStatus];
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)evaluateStatus {
    if (self.master.canPerformSync && !self.hasSynced && [self isTimeIntervalMatched]) {
        dout_info(@"Start auto sync.");
        [self.master startSync];
    }
}

- (BOOL)isTimeIntervalMatched {
    if (self.lastSyncCheckTime && !DebugAPIUpdateForceAutoUpdate) {
        return fabs([self.lastSyncCheckTime timeIntervalSinceNow]) > self.syncCheckInterval;
    }
    return YES;
}

- (void)onWatchToSyncCheckTimeMatchTimerFired {
    _doutwork()
    self.syncCheckInterval = self.syncCheckInterval;
    [self.watchToSyncCheckTimeMatchTimer invalidate];
    self.watchToSyncCheckTimeMatchTimer = nil;
}

- (void)syncFinshed:(BOOL)success {
    dout_info(@"Auto sync finshed.")
    self.hasSynced = YES;
    
    if (success) {
        self.lastSyncCheckTime = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:self.lastSyncCheckTime forKey:UDkLastUpdateCheckTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([self.master respondsToSelector:@selector(clearAfterSync)]) {
        [self.master clearAfterSync];
    }
}

@end
