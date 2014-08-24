//
//  TableListTVC.h
//  TableList
//
//  Created by Bing Xiong on 7/27/14.
//  Copyright (c) 2014 Mobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoListCell.h"
#import "RESideMenu.h"

@interface TableListTVC : UITableViewController <RESideMenuDelegate>

@property (nonatomic, strong) NSArray *	listModel; //of JSON models
@property (nonatomic, strong) InfoListCell *tempCell;

@end
