
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

+ (UIColor *)globalPlaceholderTextColor {
    static UIColor *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [UIColor colorWithRGBHex:0x898989 alpha:1];
    });
	return sharedInstance;
}

@end


@implementation UIImage (App)


@end

@implementation NSString (App)

- (BOOL)isValidEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidPhoneNumber {
	NSString * MOBILE = @"^1\\d{10}$";
	NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}

@end
