/*!
    MBTableView
    v 0.3

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"
#import "MBTableViewPullToFetchControl.h"
#import "RFTableViewCellHeightDelegate.h"

/**
 Table view 基类

 dataSorce 要留空，这个类只支持单 section 的情形。

 封装了分页的数据获取（包括下拉刷新、上拉加载更多，数据到底处理），Auto layout cell 自动高度等功能。
 其 delegate 要实现 MBTableViewDelegate 中的方法。
 */
@interface MBTableView : UITableView <
    RFInitializing,
    UITableViewDataSource
>
@property (strong, nonatomic) NSMutableArray *items;

@property (strong, nonatomic) RFTableViewCellHeightDelegate *cellHeightManager;
@property (strong, nonatomic) MBTableViewPullToFetchControl *pullToFetchController;

@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSUInteger pageSize;

/// 刷新数据，会重置 cell 高度缓存
- (void)reload;

/// 使用 Auto Layout 更新 cell 高度
- (void)updateCellHeightAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateCellHeightOfCell:(UITableViewCell *)cell;
@end

/**
 可选协议，标明 cell 有 item 属性
 */
@protocol MBTableViewCellEntityExchanging <NSObject>
@property (strong, nonatomic) id item;
@end

/**
 这个协议比较特殊，RFTableViewCellHeightDelegate 的两个方法变成必须的

 数据获取可以 delegate 完全实现（相应的数据添加、刷新、状态控制都要自行处理），或只提供必须的参数
 */
@protocol MBTableViewDelegate <RFTableViewCellHeightDelegate>
@optional
/// 如果 delegate 不实现该方法，下面两个方法就是必须的了
- (void)fetchItemsWithPageFlag:(BOOL)nextPage;

- (NSString *)fetchAPIName;
- (NSMutableDictionary *)fetchParameters;
@end

/*! Change log
 
 0.3
 - 增加更新 cell 高度的方法
 - 补上内容为空的状态更新

 0.2
 - 把分页、数据获取等逻辑真正集成进来

 */
