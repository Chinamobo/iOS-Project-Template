/*!
    UIKit+App

    Copyright © 2013-2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0

    全局资源共享

    把可重复利用的资源放在这里
 */
#import <UIKit/UIKit.h>

@interface UIColor (App)

+ (UIColor *)globalTintColor;
+ (UIColor *)globalHighlightedTintColor;
+ (UIColor *)globalDisabledTintColor;

/// 占位符文本颜色
+ (UIColor *)globalPlaceholderTextColor;

@end

@interface UIImage (App)

@end
