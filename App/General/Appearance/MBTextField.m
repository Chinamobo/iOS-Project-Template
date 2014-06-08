
#import "MBTextField.h"

@implementation MBTextField
RFInitializingRootForUIView

- (void)onInit {
    self.textEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
}

- (void)afterInit {

}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, self.textEdgeInsets);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
