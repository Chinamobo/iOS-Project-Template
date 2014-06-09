/*!
    MBTableView
    v 0.1

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"
#import "MBTableViewPullToFetchControl.h"
#import "RFTableViewCellHeightDelegate.h"


/**
 封装常用 table view 特性：
 
 - 使用 Auto Layout 自动计算 cell 高度
 
 */
@interface MBTableView : UITableView <
    RFInitializing
>

@property (strong, nonatomic) NSMutableArray *items;

@property (assign, nonatomic) int page;
@property (assign, nonatomic) NSUInteger pageSize;

@property (strong, nonatomic) MBTableViewPullToFetchControl *fetchControl;
@property (strong, nonatomic) RFTableViewCellHeightDelegate *cellHeightManager;
@end
