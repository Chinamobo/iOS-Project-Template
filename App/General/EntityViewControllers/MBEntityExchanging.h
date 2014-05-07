/*!
    MBEntityExchanging

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import <Foundation/Foundation.h>

/**
 标准视图间 model 交换协议
 
 分成两部分，一是更新界面的规则，二是更新数据的规则。
 可选的是本身会有一个 model 属性或 model 集合的属性

 具体见下面协议方法的说明
 */
@protocol MBEntityExchanging <NSObject>

@optional

@property (strong, nonatomic) id item;
@property (strong, nonatomic) NSArray *items;

@required

#pragma mark - 界面更新

/** 
 更新界面操作

 子类应该在开头调用 super
 */
- (void)updateUIForItem;

/**
 标记 model 更新了，需要刷新界面
 */
- (void)setNeedsUpdateUIForItem;

/**
 尝试立即更新界面，如果没有标记需要更新则不会更新

 默认会在 viewDidAppear: 时执行
 */
- (void)updateUIForItemIfNeeded;

#pragma mark - 数据获取

/**
 获取数据操作

 子类应该在结尾调用 super，默认实现不触发界面更新
 */
- (void)updateItem;

/**
 标记需要重新获取 Item
 */
- (void)setNeedsUpdateItem;

/**
 尝试立即获取新数据，如果没有标记需要更新则不会执行

 默认会在 viewDidAppear: 时执行
 */
- (void)updateItemIfNeeded;

@end
