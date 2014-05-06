
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
}

@end
