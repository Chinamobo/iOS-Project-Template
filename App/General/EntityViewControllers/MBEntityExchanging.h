/**
 MBEntityExchanging
 
 标准视图间 model 交换协议
 */

#import <Foundation/Foundation.h>

@protocol MBEntityExchanging <NSObject>

@optional

@property (strong, nonatomic) id item;
@property (strong, nonatomic) NSArray *items;

@required

#pragma mark - 界面更新

/// 更新界面操作
/// 子类应该在开头调用 super
- (void)updateUIForItem;

/// 标记 model 更新了，需要刷新界面，默认会在 viewDidAppear: 时检查尝试执行
- (void)setNeedsUpdateUIForItem;
- (void)updateUIForItemIfNeeded;

#pragma mark - 数据获取

/// 获取数据操作
/// 子类应该在结尾调用 super
- (void)updateItem;

/// 标记需要重新获取 Item，默认会在 viewDidAppear: 时检查更新
- (void)setNeedsUpdateItem;
- (void)updateItemIfNeeded;

@end
