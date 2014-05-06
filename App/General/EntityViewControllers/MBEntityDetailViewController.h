//
//  MBEntityDetailViewController.h
//  CarPointing
//
//  Created by BB9z on 4/30/14.
//  Copyright (c) 2014 Chinamobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBEntityExchanging.h"

/**

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
