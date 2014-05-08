
#import "UIKit+App.h"
#import "RFDrawImage.h"

@implementation UIColor (App)

+ (UIColor *)globalTintColor {
    static UIColor *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [UIColor colorWithRGBHex:0xFF0000 alpha:1];
    });
	return sharedInstance;
}

+ (UIColor *)globalHighlightedTintColor {
    static UIColor *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self globalTintColor] mixedColorWithRatio:.25 color:[UIColor colorWithRGBHex:0xFFFFFF]];
    });
	return sharedInstance;
}

+ (UIColor *)globalDisabledTintColor {
    static UIColor *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [UIColor colorWithRGBHex:0xCCCCCC alpha:1];
    });
	return sharedInstance;
}

@end


@implementation UIImage (App)


@end
