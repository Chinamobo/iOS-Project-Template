
#import "MBFixWidthImageView.h"

@implementation MBFixWidthImageView

- (CGSize)intrinsicContentSize {
    CGSize imageSize = self.image.size;
    CGFloat width = self.bounds.size.width;

    if (imageSize.width == 0) {
        return CGSizeMake(width, 0);
    }

    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFit: {
            if (width > imageSize.width) {
                return CGSizeMake(width, imageSize.height);
            }
            // Else continue as fill
        }
        case UIViewContentModeScaleToFill:
        case UIViewContentModeScaleAspectFill: {
            return CGSizeMake(width, imageSize.height/imageSize.width*width);
        }

        default:
            return CGSizeMake(width, imageSize.height);
    }
}

@end
