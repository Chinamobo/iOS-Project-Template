
#import "MBSegmentedControl.h"
#import "RFDrawImage.h"
#import "UIView+RFAnimate.h"
#import "UIKit+App.h"

CGFloat MBSegmentedControlHeight = 29.f;
CGFloat MBSegmentedControlCornerRadius = 4.f;
CGFloat MBSegmentedControlCellWidthDefault = 80.f;

@implementation MBSegmentedControl
RFInitializingRootForUIView

- (void)onInit {
    if (!self.tintColor) {
        self.tintColor = [UIColor globalTintColor];
    }
    self.height = MBSegmentedControlHeight;

    self.layer.cornerRadius = MBSegmentedControlCornerRadius;
    self.layer.borderWidth = 1.0f;
    [self updateAppearance];
}

- (void)afterInit {
}

- (CGSize)intrinsicContentSize {
    CGSize contentSize = [super intrinsicContentSize];
    contentSize.height = MAX(MBSegmentedControlHeight, contentSize.height);
    return contentSize;
}

- (void)setFrame:(CGRect)frame {
    // keep the minimal size
    if (frame.size.height <= 1.0f) {
        frame.size.height = MBSegmentedControlHeight;
    }
    if (frame.size.width <= 1.0f) {
        frame.size.width = 1.0f + MBSegmentedControlCellWidthDefault * self.numberOfSegments;
    }
    [super setFrame:frame];
}

- (void)updateAppearance {
    UIImage *backgroundImage = [UIImage new];
    UIEdgeInsets corners = UIEdgeInsetsMake(MBSegmentedControlCornerRadius, MBSegmentedControlCornerRadius, MBSegmentedControlCornerRadius, MBSegmentedControlCornerRadius);
    UIImage *selectedBackgroundImage = [RFDrawImage imageWithRoundingCorners:corners size:CGSizeMake(12, self.height) fillColor:self.tintColor strokeColor:nil strokeWidth:0 boxMargin:UIEdgeInsetsZero resizableCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) scaleFactor:0];
    UIImage *highlightedBackgroundImage = [RFDrawImage imageWithRoundingCorners:corners size:CGSizeMake(12, self.height) fillColor:[self.tintColor mixedColorWithRatio:.25 color:[UIColor colorWithRGBHex:0xFFFFFF]] strokeColor:nil strokeWidth:0 boxMargin:UIEdgeInsetsZero resizableCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) scaleFactor:0];

    [self setTitleTextAttributes:@{ UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero], UITextAttributeTextColor : self.tintColor, UITextAttributeFont : [UIFont systemFontOfSize:13] } forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor whiteColor] } forState:UIControlStateHighlighted];

    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

    [self setDividerImage:[RFDrawImage imageWithSizeColor:(CGSize){ 1, 1 } fillColor:self.tintColor] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    self.layer.borderColor = self.tintColor.CGColor;
}

@end