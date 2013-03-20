/*!
    MBFixWidthImageView
    v 1.0

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import <UIKit/UIKit.h>

/**
 等比例显示的，高度自适应的 image view
 
 Auto layout 下，image view 的 intrinsicContentSize 会与图像尺寸保持一致，当图像尺寸较小时，一切都很好。
 但当图像被压缩时，比如宽度受限且 contentMode 是 UIViewContentModeScaleAspectFit 时，高度依旧是原始尺寸，但宽度被压缩了，视图上下就会留有空白。这个类就在这方面进行了优化。
 */
@interface MBFixWidthImageView : UIImageView
@end
