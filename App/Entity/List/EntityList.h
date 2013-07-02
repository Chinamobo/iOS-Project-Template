//
//  EntityList.h
//  App
//
//  Created by BB9z on 13-7-2.
//  Copyright (c) 2013年 Chinamobo Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Entity;

@interface EntityList : UITableViewController

@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL reachEnd;

@end


@interface EntityListCell : UITableViewCell
@property (strong, nonatomic) Entity *entity;

@end
