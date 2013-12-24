/*!
    Navigation Bar
    MBAppearanceConfig
 
    Copyright (c) 2013 BB9z
    https://github.com/BB9z/iOS-Project-Template
 
    The Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

/// 全局导航样式设置
/// 支持 iOS 6 以上，需要至少 iOS 7 SDK
/// 需要 RFKit ( https://github.com/BB9z/RFKit ) 或 RFUI ( https://github.com/RFUI/Core )
/// 修改下面的宏设置以启用关闭相应特性

#define __MBACNavigationBarEnabled 1

#pragma mark - 背景设置

// 是否使用自定义导航栏背景图
// 背景图名称需设置为 navigationBarBackground
#define __MBACNavigationBar_CustomBackground 1

// 移除自定义背景下的阴影（未设置背景则阴影不会被移除）
#define __MBACNavigationBar_RemoveBarShadow 0

// 导航栏颜色
// 设置为十六机制数值，如 0x4088CF。设为 0 以禁用
#define __MBACNavigationBar_BarTintColor 0xFDC915
#define __MBACNavigationBar_BarTintColor_iOS6 __MBACNavigationBar_BarTintColor

#pragma mark - 标题设置

// 标题字体名称，iOS 7 以后有效
// 需要设置为 UIFont 对象，如 [UIFont fontWithName:@"Zapfino" size:10]，为 0 忽略
#define __MBACNavigationBar_TitleFont 0

// 标题颜色
// 设置为十六机制数值，如 0x2384d0，为 0 忽略颜色设置
#define __MBACNavigationBar_TitleColor 0xFFFFFF

// 标题颜色 Alpha
// 默认 1
#define __MBACNavigationBar_TitleColorAlpha 1

// 标题阴影颜色
// 默认 [UIColor colorWithRGBHex:0x000000 alpha:0.3333]，为 0 不修改阴影样式
#define __MBACNavigationBar_TitleShadowColor\
    [UIColor clearColor]

// 标题阴影偏移量
// 默认 0, 0
#define __MBACNavigationBar_TitleShadowOffsetX 0
#define __MBACNavigationBar_TitleShadowOffsetY 0

// 标题阴影模糊量
// 默认 0.f，测试无效？
#define __MBACNavigationBar_TitleShadowBlurRadius 0

// 导航标题竖直方向的位移量
// 如 2、-3，为 0 忽略
#define __MBACNavigationBar_TitleVerticalPositionAdjustment 0

#pragma mark - 按钮设置
// 按钮颜色设置
// 设置为十六机制数值，如 0xFFFFFF，为 0 忽略颜色设置
#define __MBACNavigationBar_ButtonItemTitleColor 0xFFFFFF
#define __MBACNavigationBar_ButtonItemTitleColorAlpha 1

// 按钮背景
#define __MBACNavigationBar_ButtonItemClearBackground 1

// 返回按钮
// 隐藏 iOS 7 返回按钮左侧默认的箭头
#define __MBACNavigationBar_BackButtonItemHideIndicatorImage 1

// 隐藏返回按钮的标题
#define __MBACNavigationBar_BackButtonItemHideTitle 1

#pragma mark - 其他


#if __MBACNavigationBarEnabled
#import <UIKit/UIKit.h>

@interface UINavigationBar (MBAppearanceConfig)
@end
#endif
