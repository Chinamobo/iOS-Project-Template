/**
    DataStack
 
    Core Data 基础构件
    请在下方引入各 ManagedObject 的头文件
 */

#import "RFCoreData.h"
#import "MBAppVersion.h"

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
