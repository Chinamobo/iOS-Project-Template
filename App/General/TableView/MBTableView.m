
#import "MBTableView.h"
#import "API.h"

@interface MBTableView ()
@end

@implementation MBTableView
RFInitializingRootForUIView

- (void)onInit {
    self.pageSize = APIConfigFetchPageSize;
    self.items = [NSMutableArray array];
}

- (void)afterInit {
    id orgDelegate = self.delegate;
    self.delegate = self.cellHeightManager;
    self.cellHeightManager.delegate = orgDelegate;

    self.fetchControl.tableView = self;
}

- (RFTableViewCellHeightDelegate *)cellHeightManager {
    if (!_cellHeightManager) {
        _cellHeightManager = [[RFTableViewCellHeightDelegate alloc] init];
    }
    return _cellHeightManager;
}

- (MBTableViewPullToFetchControl *)fetchControl {
    if (!_fetchControl) {
        _fetchControl = [[MBTableViewPullToFetchControl alloc] init];
    }
    return _fetchControl;
}

- (void)reloadData {
    [self.cellHeightManager invalidateCellHeightCache];
    [super reloadData];
}

@end
