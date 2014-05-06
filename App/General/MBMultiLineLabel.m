
#import "MBMultiLineLabel.h"

@implementation MBMultiLineLabel

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
//    self.preferredMaxLayoutWidth = CGRectGetWidth(bounds);
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    _dout_size(size)
    if (size.width == 0) {
        size.width = self.preferredMaxLayoutWidth;
    }

    if (size.height < 22) {
        size.height = 22;
    }
    _dout_size(size)
    return size;
}

@end
