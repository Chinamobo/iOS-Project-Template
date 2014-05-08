/*!
    MBApp

    Copyright © 2013-2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import <Foundation/Foundation.h>

/**
 全局变量中心

 你应该避免使用全局变量，全局变量的存在十有七八都是不合适的。
 但适当的引入全局变量可以极大的简化各个模块，提高模块间的数据交换效率。

 如果你不得不用全局变量，把它加到这里吧。这个模块在所有文件中均可访问。
 */
@interface MBApp : NSObject

+ (instancetype)status;

@end
