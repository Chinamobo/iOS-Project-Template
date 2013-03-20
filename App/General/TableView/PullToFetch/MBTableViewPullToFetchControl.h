/*!
    MBTableViewPullToFetchControl
    v 0.1

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFTableViewPullToFetchPlugin.h"

/**
 RFTableViewPullToFetchPlugin 只是处理了下拉、上推的逻辑，没有包含外观。
 
 这个类对外观进行了进一步的封装，外观的调整需修改 MBRefreshHeaderView 和 MBRefreshFooterView。
 */
@interface MBTableViewPullToFetchControl : RFTableViewPullToFetchPlugin
@end
