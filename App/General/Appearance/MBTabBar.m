
#import "MBTabBar.h"
#import "UIKit+App.h"

@interface MBTabBar ()
@property (strong, nonatomic) id itemAppearance;
@end

@implementation MBTabBar
RFInitializingRootForUIView

- (void)onInit {
    self.barColor = [UIColor whiteColor];
    self.itemTintColor = [UIColor colorWithRGBHex:0x929292];
    self.itemHighlightedColor = [UIColor globalTintColor];
    self.selectionIndicatorImage = [UIImage new];

    self.itemAppearance = [UITabBarItem appearanceWhenContainedIn:[self class], nil];
    if ([self respondsToSelector:@selector(setTintColor:)]) {
        self.tintColor = [UIColor globalTintColor];
    }
}

- (void)afterInit {
    [self updateAppearance];
}

- (void)setItems:(NSArray *)items {
    [super setItems:items];
    [self updateItemAppearance];
}

- (void)updateItemAppearance {
    for (UITabBarItem *item in self.items) {
        UIImage *image = item.image;
        if (!image) {
            continue;
        }

        UIImage *selectedImage = image;
        UIImage *unselectedImage = image;

        if (self.displayItemImageAsOriginal) {
            if (!RF_iOS7Before) {
                selectedImage = item.selectedImage;
                if (selectedImage.renderingMode != UIImageRenderingModeAlwaysOriginal) {
                    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                }

                if (unselectedImage.renderingMode != UIImageRenderingModeAlwaysOriginal) {
                    unselectedImage = [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                }
            }
        }
        else {
            selectedImage = [image imageOnlyKeepsAlphaWithTintColor:self.itemHighlightedColor];
            unselectedImage = [image imageOnlyKeepsAlphaWithTintColor:self.itemTintColor];
        }

        [item setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
    }
}

- (void)updateAppearance {
    // iOS 7 的上边线是为提供的 shadowImage
    if (RF_iOS7Before && !self.shadowImage) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 3), NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor colorWithRGBHex:0xB2B2B2] set];
        CGContextFillRect(context, CGRectMake(0, 2.5, 1, 0.5));

        UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.shadowImage = shadowImage;
    }

    if (!self.backgroundImage) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.barColor set];
        CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
        UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.backgroundImage = backgroundImage;
    }

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (RF_iOS7Before) {
        NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] initWithCapacity:3];
        textAttributes[UITextAttributeFont] = [UIFont systemFontOfSize:10];
        textAttributes[UITextAttributeTextColor] = self.itemTintColor;
        [self.itemAppearance setTitleTextAttributes:textAttributes.copy forState:UIControlStateNormal];

        textAttributes[UITextAttributeTextColor] = self.itemHighlightedColor;
        [self.itemAppearance setTitleTextAttributes:textAttributes.copy forState:UIControlStateHighlighted];
    }
#endif

    [self updateItemAppearance];
}

@end
