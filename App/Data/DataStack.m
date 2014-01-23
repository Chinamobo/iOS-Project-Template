
#import "DataStack.h"
#import "debug.h"

@interface DataStack ()
@property (strong, nonatomic) id applicationWillTerminateNotificationObserver;
@property (strong, nonatomic) id applicationWillResignActiveNotificationObserver;
@end

@implementation DataStack

+ (instancetype)sharedInstance {
    static DataStack *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
	return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.applicationWillTerminateNotificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self save];
        }];
        self.applicationWillResignActiveNotificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self save];
        }];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.applicationWillResignActiveNotificationObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.applicationWillTerminateNotificationObserver];
}

- (NSURL *)dataBaseURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *directoryURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] firstObject];
    BOOL isDirectory = YES;
    if (![fileManager fileExistsAtPath:[directoryURL path] isDirectory:&isDirectory]) {
        RFAssert(isDirectory, @"指定目录实际是文件");
        NSError __autoreleasing *e = nil;
        [fileManager createDirectoryAtURL:directoryURL withIntermediateDirectories:YES attributes:nil error:&e];
        if (e) dout_error(@"%@", e);
    }
    NSURL *baseURL = [directoryURL URLByAppendingPathComponent:@".record"];
    return baseURL;
}

- (BOOL)save {
    NSError __autoreleasing *e = nil;
    if (![self.managedObjectContext save:&e]) {
        dout_error(@"ManagedObjectContext saved failed: %@", e);
        return NO;
    }
    return YES;
}

#pragma mark - Core Data Stack
- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        if (self.persistentStoreCoordinator) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        }
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"mom" subdirectory:@"Model.momd"];
        RFAssert(modelURL, @"Model地址需要修改");
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.dataBaseURL options:@{
                       NSMigratePersistentStoresAutomaticallyOption : @YES,
                             NSInferMappingModelAutomaticallyOption : @YES
              } error:&error]) {
            if (DebugResetPersistentStoreIfCannotAutomaticallyMigrated) {
                dout_warning(@"数据模型不兼容，原有数据被清理");
                [[NSFileManager defaultManager] removeItemAtURL:self.dataBaseURL error:nil];
                RFAssert([_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.dataBaseURL options:nil error:nil], @"数据库不能被强制重建");
            }
            else {
                RFAssert(!error, @"数据模型不兼容了：%@", error);
            }
        }
    }
    return _persistentStoreCoordinator;
}

#pragma mark - 快速访问
+ (NSManagedObjectContext *)managedObjectContext {
    return [self sharedInstance].managedObjectContext;
}

+ (BOOL)save {
    return [[self sharedInstance] save];
}

@end
