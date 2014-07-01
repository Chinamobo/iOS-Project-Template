/*!
    MBSegmentedControl
    v 1.1

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"

/**
 iOS 7 外观的 UISegmentedControl
 */
@interface MBSegmentedControl : UISegmentedControl <
    RFInitializing
>
@property (strong, nonatomic) UIColor *tintColor;
@end
