//
//  ListDetailVC.h
//  TableList
//
//  Created by Bing Xiong on 7/27/14.
//  Copyright (c) 2014 Mobo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ORDER_ID    @"order_id"
#define TITLE       @"title"
#define DATE        @"date"

@interface ListDetailVC : UIViewController
@property (nonatomic,strong) NSDictionary *details;
@end
