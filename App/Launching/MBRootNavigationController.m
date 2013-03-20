
#import "MBRootNavigationController.h"

MBRootNavigationController *MBRootNavigationControllerGlobalInstance;

@interface MBRootNavigationController ()
@end

@implementation MBRootNavigationController
RFUIInterfaceOrientationSupportNavigation

- (void)awakeFromNib {
    [super awakeFromNib];

    self.delegate = self;
    self.preferredNavigationBarHidden = self.navigationBarHidden;
}

+ (instancetype)globalNavigationController {
    return MBRootNavigationControllerGlobalInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!MBRootNavigationControllerGlobalInstance) {
        MBRootNavigationControllerGlobalInstance = self;
    }
}

- (void)setPreferredNavigationBarHidden:(BOOL)preferredNavigationBarHidden {
    _preferredNavigationBarHidden = preferredNavigationBarHidden;
    BOOL shouldHide = preferredNavigationBarHidden;

    id<MBNavigationBehaving> vc = (id<MBNavigationBehaving>)self.topViewController;
    if ([vc respondsToSelector:@selector(prefersNavigationBarHiddenForNavigationController:)]) {
        shouldHide = [vc prefersNavigationBarHiddenForNavigationController:self];
    }

    if (self.navigationBarHidden != shouldHide) {
        [self setNavigationBarHidden:shouldHide animated:NO];
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController<MBNavigationBehaving> *)viewController animated:(BOOL)animated {
    RFAssert(navigationController == self, nil);

    BOOL shouldHide = self.preferredNavigationBarHidden;
    if ([viewController respondsToSelector:@selector(prefersNavigationBarHiddenForNavigationController:)]) {
        shouldHide = [viewController prefersNavigationBarHiddenForNavigationController:self];
    }

    if (self.navigationBarHidden != shouldHide) {
        [self setNavigationBarHidden:shouldHide animated:animated];
    }

    // 修正 iOS 6 下与按钮位置与 iOS 7 的偏差
    if (RF_iOS7Before) {
        [viewController.navigationItem.leftBarButtonItem setTitlePositionAdjustment:UIOffsetMake(-4.5, .5) forBarMetrics:UIBarMetricsDefault];
    }
}


//! REF: https://github.com/onegray/UIViewController-BackButtonHandler
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {

	if (self.viewControllers.count < navigationBar.items.count) {
		return YES;
	}

	BOOL shouldPop = YES;
	UIViewController<MBNavigationBehaving>* vc = (id)[self topViewController];
	if([vc respondsToSelector:@selector(shouldPopOnBackButtonTappedForNavigationController:)]) {
		shouldPop = [vc shouldPopOnBackButtonTappedForNavigationController:self];
	}

	if (shouldPop) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self popViewControllerAnimated:YES];
		});
	}
    else {
		// Workaround for iOS7.1. Thanks to @boliva - http://stackoverflow.com/posts/comments/34452906
        [UIView animateWithDuration:.25 animations:^{
            for (UIView *subview in [navigationBar subviews]) {
                if (subview.alpha < 1.) {
                    subview.alpha = 1.;
                }
            }
        }];
	}

	return NO;
}

@end

@implementation MBRootNavigationBar
@end
