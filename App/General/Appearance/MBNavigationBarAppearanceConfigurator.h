/*!
    MBNavigationBarAppearanceConfigurator
    v 1.0

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBAppearanceConfigurator.h"

/**
 控制导航栏整体风格

 @const MBNavigationBarAppearanceStyleNotChange 除了设置定义好的属性外，不做特殊处理
 @const MBNavigationBarAppearanceStyle_iOS7 在旧版本的设备上模拟 iOS 7 的效果
 */
typedef NS_ENUM(short, MBNavigationBarAppearanceStyle) {
    MBNavigationBarAppearanceStyleNotChange = 0,
    MBNavigationBarAppearanceStyle_iOS7
};

/**
 导航栏外观设置器
 
 如果你只想给特定对象设置样式，可以设置 appearance 和 barButtonItemAppearance

 示例：
 @code
 MBNavigationBarAppearanceConfigurator *nac = [MBNavigationBarAppearanceConfigurator new];
 nac.backgroundImage = [UIImage imageNamed:RF_iOS7Before? @"NavigationBarBackgroundOld" : @"NavigationBarBackground"];

 // 在 iOS 6 上模拟 iOS 7 外观
 nac.style = MBNavigationBarAppearanceStyle_iOS7;
 [nac applay];
 @endcode
 
 已知问题：
 - 用 backButtonIcon 设置返回按钮时，iOS 6 下标题仍会占据位置，如果过长会吧中间的标题挤到右侧

 */
@interface MBNavigationBarAppearanceConfigurator : MBAppearanceConfigurator
@property (strong, nonatomic) id barButtonItemAppearance;

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

/// 要清空标题和按钮文字的阴影
/// 默认 YES
@property (assign, nonatomic) BOOL clearTitleShadow;

#pragma mark - 按钮
/// 按钮颜色
/// 默认使用全局 tint color
@property (strong, nonatomic) UIColor *itemTitleColor;
@property (strong, nonatomic) UIColor *itemTitleHighlightedColor;
@property (strong, nonatomic) UIColor *itemTitleDisabledColor;

/// 清空按钮背景
/// 默认 YES
@property (assign, nonatomic) BOOL clearItemBackground;

/**
 返回按钮图像，建议尺寸高度为 22，并在右侧留有空白

 非空时，返回按钮将只显示这个图像，隐藏标题和箭头
 */
@property (strong, nonatomic) UIImage *backButtonIcon;
@end
