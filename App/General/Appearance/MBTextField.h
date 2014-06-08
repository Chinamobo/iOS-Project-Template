/*!
    MBTextField

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"

/**
 TextField 基类

 主要用于外观定制
 */
@interface MBTextField : UITextField <
    RFInitializing
>

/**
 文字与边框的边距
 
 默认上下 7pt，左右 10pt
 */
@property (assign, nonatomic) UIEdgeInsets textEdgeInsets;
@end
