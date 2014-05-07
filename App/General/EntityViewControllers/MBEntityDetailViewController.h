/*!
    MBEntityDetailViewController
 
    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import <UIKit/UIKit.h>
#import "MBEntityExchanging.h"

/**
 Model 显示视图基类
 
 符合 MBEntityExchanging 协议，通过 segue 跳转时会尝试设置 destinationViewController 的 item 属性为自己的 item
 */
@interface MBEntityDetailViewController : UIViewController <
    MBEntityExchanging
> {
@protected
    BOOL _needsUpdateItem;
    BOOL _needsUpdateUIForItem;
}

@property (strong, nonatomic) id item;

/// 会尝试设置 destinationViewController 的 item 属性为自己的 item
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
