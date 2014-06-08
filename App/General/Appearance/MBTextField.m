
#import "MBTextField.h"

@implementation MBTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    // 文字与边距的距离
    UIEdgeInsets textMargin = UIEdgeInsetsMake(7, 10, 7, 10);
    return UIEdgeInsetsInsetRect(bounds, textMargin);
}

@end
