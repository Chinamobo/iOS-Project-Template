
#import "MBRootNavigationController.h"

MBRootNavigationController *GlobalInstance;

@interface MBRootNavigationController ()
@end

@implementation MBRootNavigationController
RFUIInterfaceOrientationSupportNavigation

- (void)awakeFromNib {
    [super awakeFromNib];

    self.delegate = self;
    self.preferredNavigationBarHidden = [UIDevice currentDevice].isPad;
}

+ (instancetype)globalNavigationController {
    return GlobalInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!GlobalInstance) {
        GlobalInstance = self;
    }
}

- (void)setPreferredNavigationBarHidden:(BOOL)preferredNavigationBarHidden {
    _preferredNavigationBarHidden = preferredNavigationBarHidden;
    id<MBNavigationBehaving> vc = (id<MBNavigationBehaving>)self.topViewController;

    if ([vc respondsToSelector:@selector(prefersNavigationBarHiddenForNavigationController:)]) {
        BOOL shouldHide = [vc prefersNavigationBarHiddenForNavigationController:self];

    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController<MBNavigationBehaving> *)viewController animated:(BOOL)animated {
    RFAssert(navigationController == self, nil);

    if ([viewController respondsToSelector:@selector(prefersNavigationBarHiddenForNavigationController:)] && [viewController prefersNavigationBarHiddenForNavigationController:self]) {
        [self setNavigationBarHidden:YES animated:animated];
    }
    else if (self.isNavigationBarHidden) {
        [self setNavigationBarHidden:NO animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController<MBNavigationBehaving> *)viewController animated:(BOOL)animated {
    RFAssert(navigationController == self, nil);
}

@end
