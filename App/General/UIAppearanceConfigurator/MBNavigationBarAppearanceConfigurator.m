//
//  MBNavigationBarAppearanceConfigurator.m
//  App
//
//  Created by BB9z on 5/6/14.
//  Copyright (c) 2014 Chinamobo. All rights reserved.
//

#import "MBNavigationBarAppearanceConfigurator.h"
#import "UIColor+App.h"
#import "RFDrawImage.h"

@implementation MBNavigationBarAppearanceConfigurator

- (id)init {
    self = [super init];
    if (self) {
        self.barColor = [UIColor whiteColor];
        self.removeBarShadow = YES;

        self.titleColor = [UIColor blackColor];

        self.itemTitleColor = [UIColor globalTintColor];
        self.itemTitleHighlightedColor = [UIColor globalHighlightedTintColor];
        self.itemTitleDisabledColor = [UIColor globalDisabledTintColor];
        self.clearTitleShadow = YES;
    }
    return self;
}

- (void)applay {
    id navigationBarAppearance = [UINavigationBar appearance];
    id itemAppearance = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    BOOL iOS7Style = (self.style == MBNavigationBarAppearanceStyle_iOS7 && RF_iOS7Before);

    // 基础颜色设置
    if (RF_iOS7Before) {
        [navigationBarAppearance setTintColor:self.barColor];
    }
    else {
        [navigationBarAppearance setBarTintColor:self.barColor];
    }

    // 背景设置
    if (self.backgroundImage) {
        [navigationBarAppearance setBackgroundImage:self.backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    if (self.removeBarShadow) {
        [navigationBarAppearance setShadowImage:UIImage.new];
    }

    NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (self.clearTitleShadow) {
        textAttributes[UITextAttributeTextShadowColor] = [UIColor clearColor];
    }

    // 标题设置
    textAttributes[RF_iOS7Before ? UITextAttributeTextColor : NSForegroundColorAttributeName] = self.titleColor;
    if (iOS7Style) {
        textAttributes[UITextAttributeFont] = [UIFont boldSystemFontOfSize:17];
        [navigationBarAppearance setTitleVerticalPositionAdjustment:1.5 forBarMetrics:UIBarMetricsDefault];
    }
    [navigationBarAppearance setTitleTextAttributes:textAttributes.copy];

    // 按钮设置
    textAttributes[RF_iOS7Before ? UITextAttributeTextColor : NSForegroundColorAttributeName] = self.itemTitleColor;
    if (iOS7Style) {
        textAttributes[UITextAttributeFont] = [UIFont systemFontOfSize:17];
        // 调整 iOS 6 下的偏移
        [itemAppearance setTitlePositionAdjustment:UIOffsetMake(4.5, .5) forBarMetrics:UIBarMetricsDefault];
        [itemAppearance setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -2.5) forBarMetrics:UIBarMetricsLandscapePhone];
    }
	[itemAppearance setTitleTextAttributes:textAttributes.copy forState:UIControlStateNormal];

    textAttributes[RF_iOS7Before ? UITextAttributeTextColor : NSForegroundColorAttributeName] = self.itemTitleHighlightedColor;
    [itemAppearance setTitleTextAttributes:textAttributes.copy forState:UIControlStateHighlighted];

    textAttributes[RF_iOS7Before ? UITextAttributeTextColor : NSForegroundColorAttributeName] = self.itemTitleDisabledColor;
    [itemAppearance setTitleTextAttributes:textAttributes.copy forState:UIControlStateDisabled];

    // iOS 6 按钮背景
    if (iOS7Style) {
        [itemAppearance setBackgroundImage:[RFDrawImage imageWithSizeColor:CGSizeMake(10, 30) fillColor:[UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

        UIEdgeInsets backImageResizeInsets = UIEdgeInsetsMake(22, 22, 0, 1);
        UIImage *backImage = [UIImage imageNamed:@"NavigationBackIndicatorImage"];

        UIImage *normal = [[backImage imageWithTintColor:self.itemTitleColor] resizableImageWithCapInsets:backImageResizeInsets];
        [itemAppearance setBackButtonBackgroundImage:normal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

        UIImage *highlight = [[backImage imageWithTintColor:self.itemTitleHighlightedColor] resizableImageWithCapInsets:backImageResizeInsets];
        [itemAppearance setBackButtonBackgroundImage:highlight forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    }
}

@end
