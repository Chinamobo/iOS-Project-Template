
#import "MBButton.h"
#import "UIButton+RFKit.h"
#import "UIButton+RFResizableBackgroundImage.h"

@implementation MBButton

+ (void)load {
    [[self appearance] setBackgroundImageResizingCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupAppearance];
}

- (void)setupAppearance {
//    [self setBackgroundImage:[UIImage imageNamed:@"button_white_disabled"] forState:UIControlStateDisabled];
//    [self setBackgroundImage:[UIImage imageNamed:@"button_white_normal"] forState:UIControlStateNormal];
//    [self setBackgroundImage:[UIImage imageNamed:@"button_white_highlighted"] forState:UIControlStateHighlighted];
//
//    [self setTitleColor:[UIColor colorWithRGBHex:0xCCCCCC] forState:UIControlStateDisabled];
//    [self setTitleColor:[UIColor colorWithRGBHex:0x157EFB] forState:UIControlStateNormal];
//    [self setTitleColor:[UIColor colorWithRGBHex:0xFFFFFF] forState:UIControlStateHighlighted];
}

@end
