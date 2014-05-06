
#import "UIColor+App.h"

@implementation UIColor (App)

+ (UIColor *)globalTintColor {
    static UIColor *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [UIColor colorWithRGBHex:0xFF0000 alpha:1];
    });
	return sharedInstance;
}

@end
