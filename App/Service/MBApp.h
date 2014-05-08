/**
 全局变量中心

 你应该避免使用全局变量，全局变量的存在十有七八都是不合适的。
 但适当的引入全局变量可以极大的简化各个模块，提高模块间的数据交换效率。
 
 如果你不得不用全局变量，把它加到这里吧。这个模块在所有文件中均可访问。
 */

#import <Foundation/Foundation.h>

@interface MBApp : NSObject

+ (instancetype)status;

@end
