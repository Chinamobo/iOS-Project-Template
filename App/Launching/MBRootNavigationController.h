/*!
    MBRootNavigationController

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import <UIKit/UIKit.h>

@protocol MBNavigationBehaving;

/**
 根导航控制器
 */
@interface MBRootNavigationController : UINavigationController <
    UINavigationControllerDelegate
>

/**
 
 */
+ (instancetype)globalNavigationController;

/**
 默认情况下，导航栏是隐藏还是显示
 
 默认值与 Stroyboard 中设置一致
 */
@property (assign, nonatomic) BOOL preferredNavigationBarHidden;
@end

@protocol MBNavigationBehaving <NSObject>
@optional

/**
 Specifies whether the view controller prefers the navigation bar to be hidden or shown.

 @return A Boolean value of YES specifies the navigation bar should be hidden. Default value is NO.
 */
- (BOOL)prefersNavigationBarHiddenForNavigationController:(MBRootNavigationController *)navigation;

@end
