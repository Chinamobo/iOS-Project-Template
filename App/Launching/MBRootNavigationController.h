/*!
    MBRootNavigationController

    Copyright (c) 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import <UIKit/UIKit.h>

@protocol MBNavigationBehaving;

@interface MBRootNavigationController : UINavigationController <
UINavigationControllerDelegate
>

+ (instancetype)globalNavigationController;

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
