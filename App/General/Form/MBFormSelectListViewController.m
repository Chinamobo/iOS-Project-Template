
#import "MBFormSelectListViewController.h"

@interface MBFormSelectListViewController ()
@end

@implementation MBFormSelectListViewController
RFUIInterfaceOrientationSupportDefault

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSArray *selectedItems = self.selectedItems;
    UITableView *tableView = self.tableView;

    for (id item in selectedItems) {
        NSUInteger idx = [self.items indexOfObject:item];
        if (idx == NSNotFound) {
            continue;
        }

        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.requireUserPressSave) {
        [self performResultCallBack];
    }
}

- (IBAction)onSaveButtonTapped:(id)sender {
    [self performResultCallBack];
}

- (void)performResultCallBack {
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    for (NSIndexPath *indexPath in indexPaths) {
        [indexSet addIndex:indexPath.row];
    }
    NSArray *selectedItems = [self.items objectsAtIndexes:indexSet];

    if (self.didEndSelection) {
        self.didEndSelection(self, selectedItems);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MBFormSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    RFAssert([cell isKindOfClass:[MBFormSelectTableViewCell class]], @"MBFormSelectListViewController 的 cell 必须是 MBFormSelectTableViewCell");
    cell.value = self.items[indexPath.row];
    return cell;
}

@end

@implementation MBFormSelectTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.accessoryType = selected? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [super setSelected:selected animated:animated];
}

- (void)setValue:(id)value {
    _value = value;
    [self displayForValue:value];
}

- (void)displayForValue:(id)value {
    self.valueDisplayLabel.text = [NSString stringWithFormat:@"%@", value];
}

@end
