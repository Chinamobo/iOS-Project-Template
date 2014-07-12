
#import "MBModalPresentSegue.h"
#import "UIViewController+RFKit.h"
#import "MBRootNavigationController.h"
#import "UIView+RFAnimate.h"

@implementation MBModalPresentSegue

- (void)RFPerform {
    UIViewController *vc = [UIViewController rootViewControllerWhichCanPresentModalViewController];
    UIView *dest = [self.destinationViewController view];
    [vc addChildViewController:self.destinationViewController];
    [vc.view addSubview:dest resizeOption:RFViewResizeOptionFill];
    [(id<MBModalPresentSegueDelegate>)self.destinationViewController setViewHidden:NO animated:YES completion:nil];
}

@end

@implementation MBModalPresentPushSegue

- (void)perform {
    [[MBRootNavigationController globalNavigationController] pushViewController:self.destinationViewController animated:YES];
}

@end

@implementation MBModalPresentViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    @weakify(self);
    [self setViewHidden:YES animated:NO completion:^{
        @strongify(self);
        [self removeFromParentViewControllerAndView];
    }];
}

- (IBAction)onCancelButtonTapped:(UIButton *)sender {
    @weakify(self);
    [self setViewHidden:YES animated:YES completion:^{
        @strongify(self);
        [self removeFromParentViewControllerAndView];
    }];
}

- (void)setViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion {
    __weak UIView *mask = self.maskView;
    __weak UIView *menu = self.containerView;
    CGFloat height = menu.height;

    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animated:animated beforeAnimations:^{
        mask.alpha = hidden? 1 : 0;
        menu.bottomMargin = hidden? 0 : -height;
    } animations:^{
        mask.alpha = hidden? 0 : 1;
        menu.bottomMargin = hidden? -height : 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

@end
