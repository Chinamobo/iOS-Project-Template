
#import "MBControlGroup.h"

@implementation MBControlGroup
RFInitializingRootForUIView

- (void)onInit {

}

- (void)afterInit {
    for (UIControl *c in self.controls) {
        [self setupItemAction:c];
    }
}

- (void)setupItemAction:(UIControl *)item {
    for (id obj in [item actionsForTarget:self forControlEvent:UIControlEventTouchUpInside]) {
        if ([obj isEqualToString:NSStringFromSelector(@selector(setSelectedControl:))]) {
            return;
        }
    }
    [item addTarget:self action:@selector(setSelectedControl:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelectedControl:(UIControl *)selectedControl {
    if (_selectedControl != selectedControl) {
        [self deselectControl:_selectedControl];
        _selectedControl.selected = NO;

        [self selectControl:selectedControl];
        selectedControl.selected = YES;

        _selectedControl = selectedControl;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

+ (NSSet *)keyPathsForValuesAffectingSelectIndex {
    return [NSSet setWithObjects:@keypathClassInstance(MBControlGroup, selectedControl), nil];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (selectIndex >= 0 && selectIndex < self.controls.count) {
        self.selectedControl = self.controls[selectIndex];
        return;
    }
    self.selectedControl = nil;
}

- (NSInteger)selectIndex {
    NSInteger idx = [self.controls indexOfObject:self.selectedControl];
    if (idx == NSNotFound) {
        return -1;
    }
    return idx;
}

- (void)selectControl:(UIControl *)control {
}

- (void)deselectControl:(UIControl *)control {
}


@end
