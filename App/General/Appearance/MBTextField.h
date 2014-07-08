/*!
    MBTextField
    v 1.2

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"

/**
 TextField 基类

 主要用于外观定制
 
 特性：

 - placeholder 样式调整，调整样式请修改代码
 - 调整了 TextField 的默认高度，调整默认高度请修改代码
 - 通过 textEdgeInsets 属性，可以修改文字与边框的距离
 - 获得焦点后自动设置高亮背景
 - 用户按换行可以自动切换到下一个输入框或执行按钮操作，只需设置 nextField 属性，键盘的 returnKeyType 如果是默认值则还会自动修改

 已知问题：
 - placeholder 样式修改在 iOS 6 上无效果
 */
@interface MBTextField : UITextField <
    RFInitializing
>

/**
 文字与边框的边距
 
 默认上下 7pt，左右 10pt
 */
@property (assign, nonatomic) UIEdgeInsets textEdgeInsets UI_APPEARANCE_SELECTOR;

/**
 按键盘上的 return 需跳转到的控件
 */
@property (weak, nonatomic) IBOutlet UIResponder *nextField;

@end
