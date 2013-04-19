
#import "DataStack.h"

@interface DataStack ()
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

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self save];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self save];
        }];
    }
    
    return self;
}

- (NSURL *)dataBaseURL {
    NSURL *baseURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    return [baseURL URLByAppendingPathComponent:@".cache"];
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
        NSDictionary *option = @{
        NSMigratePersistentStoresAutomaticallyOption : @YES,
        NSInferMappingModelAutomaticallyOption : @YES
        };
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.dataBaseURL options:option error:&error]) {
            RFAssert(!error, @"数据模型不兼容了：%@", error);
        }
    }
    return _persistentStoreCoordinator;
}

@end


@implementation NSManagedObjectContext (DataStack)
- (BOOL)save {
    NSError __autoreleasing *e = nil;
    if (![self save:&e]) {
        dout_error(@"ManagedObjectContext saved failed: %@", e);
        return NO;
    }
    return YES;
}


@end
