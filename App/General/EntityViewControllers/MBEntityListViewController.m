
#import "MBEntityListViewController.h"

@implementation MBEntityListViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self updateItemIfNeeded];
    [self updateUIForItemIfNeeded];
}


- (void)updateUIForItem {
    _needsUpdateUIForItem = NO;
}

- (void)setNeedsUpdateUIForItem {
    _needsUpdateUIForItem = YES;
}

- (void)updateUIForItemIfNeeded {
    if (_needsUpdateUIForItem) {
        [self updateUIForItem];
    }
}


- (void)updateItem {
    _needsUpdateItem = NO;
}

- (void)setNeedsUpdateItem {
    _needsUpdateItem = YES;
}

- (void)updateItemIfNeeded {
    if (_needsUpdateItem) {
        [self updateItem];
    }
}

@end
