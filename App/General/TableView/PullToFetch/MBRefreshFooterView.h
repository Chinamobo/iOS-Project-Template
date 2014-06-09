/*!
    MBRefreshFooterView
    v 0.1

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import <UIKit/UIKit.h>
#import "RFTableViewPullToFetchPlugin.h"

@interface MBRefreshFooterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

/**
 列表内容为空。
 
 置为 YES 将显示 emptyLabel 的内容
 */
@property (assign, nonatomic) BOOL empty;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (void)updateStatus:(RFPullToFetchIndicatorStatus)status distance:(CGFloat)distance control:(RFTableViewPullToFetchPlugin *)control;

@end
