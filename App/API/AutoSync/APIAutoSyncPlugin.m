
#import "APIAutoSyncPlugin.h"
#import "debug.h"

NSString *const UDkLastUpdateCheckTime = @"Last Update Check Time";
static void *const APIAutoSyncPluginKVOContext = (void *)&APIAutoSyncPluginKVOContext;

@interface APIAutoSyncPlugin ()
@property (RF_WEAK, nonatomic) id<APIAutoSyncPluginDelegate> master;
@property (strong, nonatomic) NSTimer *watchToSyncCheckTimeMatchTimer;
@end

@implementation APIAutoSyncPlugin

- (id)init {
    RFAssert(false, @"Use initWithMaster: instead.");
    return nil;
}

- (id)initWithMaster:(id<APIAutoSyncPluginDelegate>)api {
    self = [super init];
    if (self) {
        self.master = api;
        
        [self addObserver:self forKeyPath:@keypath(self, staues) options:NSKeyValueObservingOptionNew context:APIAutoSyncPluginKVOContext];
        [self addObserver:self forKeyPath:@keypath(self, syncCheckInterval) options:NSKeyValueObservingOptionNew context:APIAutoSyncPluginKVOContext];

        self.lastSyncCheckTime = [[NSUserDefaults standardUserDefaults] objectForKey:UDkLastUpdateCheckTime];
        _dout_float([self.lastSyncCheckTime timeIntervalSinceNow])
    }
    return self;
}

- (void)dealloc {
    _doutwork()
    [self removeObserver:self forKeyPath:@keypath(self, staues) context:APIAutoSyncPluginKVOContext];
    [self removeObserver:self forKeyPath:@keypath(self, syncCheckInterval) context:APIAutoSyncPluginKVOContext];
}

+ (NSSet *)keyPathsForValuesAffectingStaues {
    APIAutoSyncPlugin *this;
    return [NSSet setWithObjects:@keypath(this, master.canPerformSync), @keypath(this, lastSyncCheckTime), @keypath(this, syncCheckInterval), nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != APIAutoSyncPluginKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if (object == self) {
        if ([keyPath isEqualToString:@keypath(self, staues)]) {
            if (self.staues & APIAutoSyncPluginStatusMasterConditionMatched
                && self.staues & APIAutoSyncPluginStatusTimeIntervalMatched
                && !(self.staues & APIAutoSyncPluginStatusFinished)) {
                dout_info(@"Start auto sync.");
                [self.master startSync];
            }
            return;
        }
        else if ([keyPath isEqualToString:@keypath(self, syncCheckInterval)]) {
            if (![self isTimeIntervalMatched]) {
                self.watchToSyncCheckTimeMatchTimer = [NSTimer scheduledTimerWithTimeInterval:self.syncCheckInterval+[self.lastSyncCheckTime timeIntervalSinceNow] target:self selector:@selector(onWatchToSyncCheckTimeMatchTimerFired) userInfo:nil repeats:NO];
            }
            return;
        }
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (APIAutoSyncPluginStatus)staues {
    if (self.master.canPerformSync) {
        _staues |= APIAutoSyncPluginStatusMasterConditionMatched;
    }
    else {
        _staues &= ~APIAutoSyncPluginStatusMasterConditionMatched;
    }
    
    _staues &= ~APIAutoSyncPluginStatusTimeIntervalMatched;
    if ([self isTimeIntervalMatched]) {
        _staues |= APIAutoSyncPluginStatusTimeIntervalMatched;
    }
    
    if (DebugAPIUpdateForceAutoUpdate) {
        _staues |= APIAutoSyncPluginStatusTimeIntervalMatched;
    }
    
    return _staues;
}

- (BOOL)isTimeIntervalMatched {
    if (self.lastSyncCheckTime) {
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
    
    self.staues |= APIAutoSyncPluginStatusFinished;
    
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
