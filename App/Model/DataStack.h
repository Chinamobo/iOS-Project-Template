/*!
    DataStack

    Copyright © 2013-2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFCoreData.h"
#import "MBAppVersion.h"

/**
 Core Data 基础构件
 */
@interface DataStack : NSObject
+ (DataStack *)sharedInstance;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (BOOL)save;

#pragma mark - 单例快速访问
+ (NSManagedObjectContext *)managedObjectContext;
+ (BOOL)save;

@end
