/**
    DataStack
 
    Core Data 管理
 */

#import <CoreData/CoreData.h>
// TODO: 把 ManagedObject 的类别在这引进来，集中引用 DataStack，过去每用一种对象就要引用一次的方式过于繁琐了

@interface DataStack : NSObject
+ (DataStack *)sharedInstance;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@interface NSManagedObjectContext (DataStack)
- (BOOL)save;
@end