/*!
    MBMultiLineLabel

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import <UIKit/UIKit.h>

/**
 这个类为了解决 Auto Layout label 自适应高度的问题
 
 细节：
 - 如果 label 是从 storyboard 中创建的，Auto layout 会按照 storybaord 中定义的宽度计算其尺寸，这意味着当 label 实际尺寸与在 storybaord 中定义的宽度不一致时，计算出来的高度可能会不正确；
 - 为了解决上述问题，需要设置 preferredMaxLayoutWidth。如果手动去设置，应当考虑 label 宽度变化的情形（比如屏幕旋转），会比较麻烦，失去了自动布局的意义；
 - preferredMaxLayoutWidth 设置的问题，我们在 setBounds 中进行了重写，这样就不用重写了，即当 label 尺寸改变时，设置 preferredMaxLayoutWidth 与新宽度一致；
 - 另一种情况是，如果 label 内容为空，自动布局的尺寸会是 0，一方面会重设尺寸导致 preferredMaxLayoutWidth 失效，为此我们重写了 intrinsicContentSize，让 label 的宽度不会自己收缩成 0；
 - 我们还限定了 label 的最低高度，如果不需要这个特性，请修改 intrinsicContentSize 方法；
 - 这个类不会设置 numberOfLines。

 */
@interface MBMultiLineLabel : UILabel

@end
