
#import "NavigationBarAppearanceConfig.h"
#import "UIColor+RFKit.h"

#if __MBACNavigationBarEnabled
@implementation UINavigationBar (MBAppearanceConfig)

+ (void)load {
    BOOL isOldSystem = (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1);
    id navigationBarAppearance = [self appearance];

#pragma mark - 背景设置

#if __MBACNavigationBar_CustomBackground
    if (__MBACNavigationBar_CustomBackgroundUsingSpecifiedVersionForOldSystem && isOldSystem) {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigationBarBackgroundOld"] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground"] forBarMetrics:UIBarMetricsDefault];
    }
#endif

#if __MBACNavigationBar_RemoveBarShadow
    [navigationBarAppearance setShadowImage:UIImage.new];
#endif


#if __MBACNavigationBar_BarTintColor
#if __MBACNavigationBar_BarTintColor_iOS6
    [navigationBarAppearance setTintColor:[UIColor colorWithRGBHex:__MBACNavigationBar_BarTintColor_iOS6]];
#else
    [navigationBarAppearance setTintColor:[UIColor colorWithRGBHex:__MBACNavigationBar_BarTintColor]];
#endif

    // iOS 7
    if ([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)]) {
        [navigationBarAppearance setBarTintColor:[UIColor colorWithRGBHex:__MBACNavigationBar_BarTintColor]];
    }
#endif

#pragma mark - 标题设置

    NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] initWithCapacity:3];

    // Note: iOS 6 上测试，在 load 方法内创建 UIFont 会产生异常
    if (!isOldSystem) {
        if (__MBACNavigationBar_TitleFont) {
            textAttributes[NSFontAttributeName] = __MBACNavigationBar_TitleFont;
        }
    }

#if __MBACNavigationBar_TitleColor
    if (isOldSystem) {
        textAttributes[UITextAttributeTextColor] = [UIColor colorWithRGBHex:__MBACNavigationBar_TitleColor alpha:__MBACNavigationBar_TitleColorAlpha];
    }
    else {
        textAttributes[NSForegroundColorAttributeName] = [UIColor colorWithRGBHex:__MBACNavigationBar_TitleColor alpha:__MBACNavigationBar_TitleColorAlpha];
    }
#endif
    if (__MBACNavigationBar_TitleShadowColor) {
        if (isOldSystem) {
            textAttributes[UITextAttributeTextShadowColor] = __MBACNavigationBar_TitleShadowColor;
            textAttributes[UITextAttributeTextShadowOffset] = [NSValue valueWithCGSize:CGSizeMake(__MBACNavigationBar_TitleShadowOffsetX, __MBACNavigationBar_TitleShadowOffsetY)];
        }
        else {
            NSShadow *shadow = NSShadow.new;
            shadow.shadowColor = __MBACNavigationBar_TitleShadowColor;
            shadow.shadowOffset = CGSizeMake(__MBACNavigationBar_TitleShadowOffsetX, __MBACNavigationBar_TitleShadowOffsetY);
            shadow.shadowBlurRadius = __MBACNavigationBar_TitleShadowBlurRadius;
            textAttributes[NSShadowAttributeName] = shadow;
        }
    }

    if (textAttributes.count) {
        [navigationBarAppearance setTitleTextAttributes:textAttributes.copy];
    }


#if __MBACNavigationBar_TitleVerticalPositionAdjustment
    [navigationBarAppearance setTitleVerticalPositionAdjustment:__MBACNavigationBar_TitleVerticalPositionAdjustment forBarMetrics:UIBarMetricsDefault];
#endif

#pragma mark - 按钮设置

    id itemAppearance = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [textAttributes removeAllObjects];
#if __MBACNavigationBar_ButtonItemTitleColor
    if (isOldSystem) {
        textAttributes[UITextAttributeTextColor] = [UIColor colorWithRGBHex:__MBACNavigationBar_ButtonItemTitleColor alpha:__MBACNavigationBar_ButtonItemTitleColorAlpha];
    }
    else {
        [itemAppearance setTintColor:[UIColor colorWithRGBHex:__MBACNavigationBar_ButtonItemTitleColor alpha:__MBACNavigationBar_ButtonItemTitleColorAlpha]];
    }
#endif

    if (textAttributes.count) {
        [itemAppearance setTitleTextAttributes:textAttributes.copy forState:UIControlStateNormal];
    }

    __unused UIImage *blankImage = [UIImage imageNamed:@"blank2"];
#if __MBACNavigationBar_ButtonItemClearBackground
    [itemAppearance setBackgroundImage:blankImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
#endif

#if __MBACNavigationBar_BackButtonItemHideIndicatorImage
    if ([UINavigationBar instancesRespondToSelector:@selector(setBackIndicatorImage:)]) {
        [navigationBarAppearance setBackIndicatorImage:blankImage];
        [navigationBarAppearance setBackIndicatorTransitionMaskImage:blankImage];
    }
#endif

#if __MBACNavigationBar_BackButtonItemHideTitle
    [itemAppearance setBackButtonTitlePositionAdjustment:UIOffsetMake(-999, 0) forBarMetrics:UIBarMetricsDefault];
#endif
}

@end
#endif
