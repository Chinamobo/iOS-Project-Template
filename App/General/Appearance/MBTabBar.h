/*!
    MBTabBar
    v 0.4

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"

/**
 iOS 7 外观的 UITabBar
 
 通常，你只需把 Storyboard 中 UITabBarController 的 tabBar 类改成 MBTabBar 即完成设置。
 如果默认的样式不满足，除了创建子类外，还可以通过 UIAppearance 设置。
 
 已知问题：
 - BarItem 的图像只支持自定义的，不支持系统预置的
 - iOS 6 下，如果 barItem 未设置图像，文字颜色不会应用
 */
@interface MBTabBar : UITabBar <
    RFInitializing
>

/**
 TabBar 背景颜色
 
 默认白色
 */
@property (strong, nonatomic) UIColor *barColor UI_APPEARANCE_SELECTOR;

/**
 BarItem 未选中时的颜色
 
 默认 #929292
 */
@property (strong, nonatomic) UIColor *itemTintColor UI_APPEARANCE_SELECTOR;

/**
 BarItem 选中时的颜色

 默认使用全局 tint color
 */
@property (strong, nonatomic) UIColor *itemHighlightedColor UI_APPEARANCE_SELECTOR;

/**
 不对 BarItem 的图片进行着色，而是原样显示

 默认 NO。如果置为 YES，在 iOS 7 之前，item 的 image 始终按原样显示，建议通过 selectionIndicatorImage 区分选择状态；在 iOS 7 及以后，除了设置 selectionIndicatorImage 外，还可以通过 selectedImage 区分选择状态。
 */
@property (assign, nonatomic) BOOL displayItemImageAsOriginal UI_APPEARANCE_SELECTOR;
@end
