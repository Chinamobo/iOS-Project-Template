//
//  DataStack.h
//  App
//
//  Created by BB9z on 13-3-19.
//  Copyright (c) 2013年 Chinamobo Co., Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DataStack : NSObject
+ (DataStack *)sharedInstance;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@interface NSManagedObjectContext (DataStack)
- (BOOL)save;
@end