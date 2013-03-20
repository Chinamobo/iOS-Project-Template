/*!
    MBAppearanceConfigurator

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import <Foundation/Foundation.h>

/**
 外观设置器基类
 */
@interface MBAppearanceConfigurator : NSObject
@property (strong, nonatomic) id appearance;

- (void)applay;
@end
