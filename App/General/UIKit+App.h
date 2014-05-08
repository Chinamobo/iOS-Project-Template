/**
 全局资源共享
 
 把可重复利用的资源放在这里
 */
#import <UIKit/UIKit.h>

@interface UIColor (App)

+ (UIColor *)globalTintColor;
+ (UIColor *)globalHighlightedTintColor;
+ (UIColor *)globalDisabledTintColor;

@end

@interface UIImage (App)

@end
