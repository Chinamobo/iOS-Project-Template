
#import "MBRefreshHeaderView.h"
#import "UIView+RFAnimate.h"

@implementation MBRefreshHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.lastTimeLabel.hidden = YES;
}

- (void)updateStatus:(RFPullToFetchIndicatorStatus)status distance:(CGFloat)distance control:(RFTableViewPullToFetchPlugin *)control {
    UILabel *label = self.statusLabel;
    BOOL isProccessing = (status == RFPullToFetchIndicatorStatusProcessing);

    self.indicatorImageView.hidden = isProccessing;
    self.activityIndicatorView.hidden = !isProccessing;

    switch (status) {
        case RFPullToFetchIndicatorStatusProcessing:
            label.text = @"正在刷新...";
            return;

        case RFPullToFetchIndicatorStatusDragging: {
            BOOL isCompleteVisible = !!(distance >= self.height);
            label.text = isCompleteVisible? @"释放刷新" : @"继续下拉以刷新";
            self.indicatorImageView.transform = (isCompleteVisible)?CGAffineTransformMakeRotation(M_PI*2) : CGAffineTransformMakeRotation(M_PI);

            return;
        }
        case RFPullToFetchIndicatorStatusDecelerating:
            label.text = @"下拉刷新";
            return;

        default:
            break;
    }
}

@end
