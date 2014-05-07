//
//  MBNavigationBarAppearanceConfigurator.h
//  App
//
//  Created by BB9z on 5/6/14.
//  Copyright (c) 2014 Chinamobo. All rights reserved.
//

#import "MBAppearanceConfigurator.h"

typedef NS_ENUM(short, MBNavigationBarAppearanceStyle) {
    MBNavigationBarAppearanceStyleNotChange = 0,
    MBNavigationBarAppearanceStyle_iOS7
};

@interface MBNavigationBarAppearanceConfigurator : MBAppearanceConfigurator

/// 导航栏外观风格
@property (assign, nonatomic) MBNavigationBarAppearanceStyle style;

#pragma mark - 导航条

/// 导航条颜色
/// 默认白色
@property (strong, nonatomic) UIColor *barColor;

/// 背景图
@property (strong, nonatomic) UIImage *backgroundImage;

/// 移除背景图阴影
/// 默认 YES
@property (assign, nonatomic) BOOL removeBarShadow;

#pragma mark - 标题
/// 标题颜色
/// 默认黑色
@property (strong, nonatomic) UIColor *titleColor;

#pragma mark - 按钮
/// 按钮颜色
/// 默认使用全局 tint color
@property (strong, nonatomic) UIColor *itemTitleColor;
@property (strong, nonatomic) UIColor *itemTitleHighlightedColor;
@property (strong, nonatomic) UIColor *itemTitleDisabledColor;

/// 要清空标题和按钮的背景么
/// 默认 YES
@property (assign, nonatomic) BOOL clearTitleShadow;
@end
