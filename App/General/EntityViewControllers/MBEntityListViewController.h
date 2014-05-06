/**
 
 
 
 
 */

#import <UIKit/UIKit.h>
#import "MBEntityExchanging.h"

@interface MBEntityListViewController : UIViewController <
    MBEntityExchanging
> {
@protected
    BOOL _needsUpdateItem;
    BOOL _needsUpdateUIForItem;
}

@property (strong, nonatomic) NSArray *items;

@end
