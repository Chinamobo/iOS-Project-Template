/*!
    MBControlGroup
    v 0.1

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"

/**
 用于管理一组 UIControl 的选择状态，这组 UIControl 同时只有一个处于 selected 状态
 
 当选择状态变化时会发送 UIControlEventValueChanged 事件。
 
 注意：当前这个类被当作 NSObject 使用，而不是一个视图，继承 UIControl 只是为了便于发送事件。未来可能扩展到自动识别 subviews 中的 UIControl。
 */
@interface MBControlGroup : UIControl <
    RFInitializing
>
@property (strong, nonatomic) IBOutletCollection(UIControl) NSArray *controls;

@property (weak, nonatomic) UIControl *selectedControl;

// < 0 未选中
@property (assign, nonatomic) NSInteger selectIndex;
@end
