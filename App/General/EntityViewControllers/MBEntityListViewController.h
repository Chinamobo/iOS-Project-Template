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

 与 MBEntityDetailViewController 类似，符合 MBEntityExchanging 协议，用于显示 model 的列表
 */
@interface MBEntityListViewController : UIViewController <
    MBEntityExchanging
> {
@protected
    BOOL _needsUpdateItem;
    BOOL _needsUpdateUIForItem;
}

@property (strong, nonatomic) NSArray *items;

@end
