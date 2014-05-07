/**
 全局共享颜色设置
 
 */
#import <UIKit/UIKit.h>

@interface UIColor (App)

+ (UIColor *)globalTintColor;
+ (UIColor *)globalHighlightedTintColor;
+ (UIColor *)globalDisabledTintColor;

@end
