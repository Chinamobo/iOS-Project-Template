/*!
    MBTextField
    v 1.1

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"

/**
 TextField 基类

 主要用于外观定制
 
 已知问题：
 - placeholder 样式修改在 iOS 6 上无效果
 */
@interface MBTextField : UITextField <
    RFInitializing,
    UITextFieldDelegate
>

/**
 文字与边框的边距
 
 默认上下 7pt，左右 10pt
 */
@property (assign, nonatomic) UIEdgeInsets textEdgeInsets;

@property (weak, nonatomic) IBOutlet UIResponder *nextField;

@end
