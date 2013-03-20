

#import "MBEntityDetailViewController.h"

@interface MBEntityDetailViewController ()

@end

@implementation MBEntityDetailViewController

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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController respondsToSelector:@selector(setItem:)]) {
        [segue.destinationViewController setItem:self.item];
    }
}

@end
