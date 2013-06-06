/**
    DataStack
 
    Core Data 基础构件
    请在下方引入各 ManagedObject 的头文件
 */

#import "RFCoreData.h"

@interface DataStack : NSObject
+ (DataStack *)sharedInstance;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (BOOL)save;

@end

@interface NSManagedObjectContext (DataStack)
- (BOOL)save DEPRECATED_ATTRIBUTE;
@end
