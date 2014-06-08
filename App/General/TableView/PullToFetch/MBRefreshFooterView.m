
#import "MBRefreshFooterView.h"
#import "UIView+RFAnimate.h"

@implementation MBRefreshFooterView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
}

- (void)setEmpty:(BOOL)empty {
    _empty = empty;
    self.backgroundImageView.hidden = !empty;
    self.emptyLabel.hidden = !empty;
    self.textLabel.hidden = empty;
}

- (void)updateStatus:(RFPullToFetchIndicatorStatus)status distance:(CGFloat)distance control:(RFTableViewPullToFetchPlugin *)control {

    if (self.empty) return;

    UILabel *label = self.textLabel;
    switch (status) {
        case RFPullToFetchIndicatorStatusFrozen:
            label.text = nil;
            return;

        case RFPullToFetchIndicatorStatusProcessing:
            label.text = @"正在加载...";
            return;

        case RFPullToFetchIndicatorStatusDragging: {
            BOOL isCompleteVisible = !!(distance >= self.height);
            label.text = isCompleteVisible? @"释放加载更多" : @"继续上拉以加载更多";

            return;
        }
        case RFPullToFetchIndicatorStatusDecelerating:
            label.text = @"上拉加载更多";
            return;

        default:
            break;
    }
}

@end
