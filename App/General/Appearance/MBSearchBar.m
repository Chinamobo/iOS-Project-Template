
#import "MBSearchBar.h"
#import "RFDrawImage.h"
#import "UIKit+App.h"

@interface MBSearchBar ()
@end

@implementation MBSearchBar

// We cannot use +load, as creat a UIFont crash on iOS 6.
+ (void)beforeInit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (RF_iOS7Before) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UIBarButtonItem *searchBarButton = [UIBarButtonItem appearanceWhenContainedIn:[MBSearchBar class], nil];
            [searchBarButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            [searchBarButton setTitleTextAttributes:@{ UITextAttributeFont:[UIFont systemFontOfSize:16], UITextAttributeTextColor : [UIColor globalTintColor], UITextAttributeTextShadowColor : [UIColor clearColor] } forState:UIControlStateNormal];
            [searchBarButton setTitleTextAttributes:@{ UITextAttributeTextColor:[UIColor lightGrayColor], UITextAttributeTextShadowColor : [UIColor clearColor] } forState:UIControlStateHighlighted];
        });
    }
#endif
}

- (instancetype)init {
    [MBSearchBar beforeInit];
    self = [super init];
    if (self) {
        [self onInit];
        [self performSelector:@selector(afterInit) withObject:self afterDelay:0];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    [MBSearchBar beforeInit];
    self = [super initWithFrame:frame];
    if (self) {
        [self onInit];
        [self performSelector:@selector(afterInit) withObject:self afterDelay:0];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    [MBSearchBar beforeInit];
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self onInit];
        [self performSelector:@selector(afterInit) withObject:self afterDelay:0];
    }
    return self;
}

- (void)onInit {
    [self updateAppearance];
}

- (void)afterInit {
    // nothing
}

- (void)updateAppearance {
    CGFloat height = self.frame.size.height;

    self.backgroundColor = [UIColor colorWithRGBHex:0xC9C9CE];
    self.backgroundImage = [RFDrawImage imageWithSizeColor:CGSizeMake(1, height) fillColor:self.backgroundColor];

    for (id searchBarSubview in self.subviews) {
        if ([searchBarSubview isKindOfClass:[UITextField class]]) {
            UITextField *textField = searchBarSubview;
            textField.backgroundColor = [UIColor whiteColor];
            textField.borderStyle = UITextBorderStyleNone;
            textField.layer.borderColor = UIColor.clearColor.CGColor;
            textField.layer.borderWidth = 0.f;
            textField.layer.cornerRadius = 5.f;
            textField.background = nil;
        }
    }

    self.scopeBarBackgroundImage = [RFDrawImage imageWithSizeColor:CGSizeMake(1, height) fillColor:self.backgroundColor];
}

@end
