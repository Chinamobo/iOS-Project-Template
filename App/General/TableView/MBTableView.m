
#import "MBTableView.h"
#import "API.h"
#import "MBRefreshFooterView.h"

@interface MBTableView ()
@property (weak, nonatomic) id<MBTableViewDelegate> delegate;
@end

@implementation MBTableView
RFInitializingRootForUIView

- (void)onInit {
    self.pageSize = APIConfigFetchPageSize;
    self.items = [NSMutableArray array];
    self.dataSource = self;
}

- (void)afterInit {
    [self cellHeightManager];
    [self pullToFetchController];
}

- (RFTableViewCellHeightDelegate *)cellHeightManager {
    if (!_cellHeightManager) {
        _cellHeightManager = [[RFTableViewCellHeightDelegate alloc] init];
        _cellHeightManager.delegate = (id)self.delegate;
        self.delegate = (id)_cellHeightManager;
    }
    return _cellHeightManager;
}

- (MBTableViewPullToFetchControl *)pullToFetchController {
    if (!_pullToFetchController) {
        MBTableViewPullToFetchControl *control = [[MBTableViewPullToFetchControl alloc] init];
        control.tableView = self;

        @weakify(self);
        [control setHeaderProcessBlock:^{
            @strongify(self);
            [self fetchItemsWithPageFlag:NO];
        }];

        [control setFooterProcessBlock:^{
            @strongify(self);
            [self fetchItemsWithPageFlag:(self.page != 0)];
        }];

        _pullToFetchController = control;
    }
    return _pullToFetchController;
}

- (void)fetchItemsWithPageFlag:(BOOL)nextPage {
    if ([self.delegate respondsToSelector:@selector(fetchItemsWithPageFlag:)]) {
        [self.delegate fetchItemsWithPageFlag:nextPage];
        return;
    }

    self.page = nextPage? self.page + 1 : 1;
    NSMutableDictionary *dic = self.delegate.fetchParameters;
    [dic addEntriesFromDictionary:@{ @"page" : @(self.page), @"pagesize" : @(self.pageSize) }];

    [API requestWithName:self.delegate.fetchAPIName parameters:dic viewController:self.viewController loadingMessage:nil modal:NO success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        if (nextPage) {
            [self.items addObjectsFromArray:responseObject];
        }
        else {
            [self.items setArray:responseObject];
            [self.cellHeightManager invalidateCellHeightCache];
            MBRefreshFooterView *fv = (id)self.pullToFetchController.footerContainer;
            fv.empty = (responseObject.count == 0);
        }
        self.pullToFetchController.footerReachEnd = !!(responseObject.count < self.pageSize);
        [self reloadData];
    } completion:^(AFHTTPRequestOperation *operation) {
        [self.pullToFetchController markProcessFinshed];
    }];
}

- (void)reload {
    if (_cellHeightManager) {
        [self.cellHeightManager invalidateCellHeightCache];
    }
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self.delegate tableView:tableView cellReuseIdentifierForRowAtIndexPath:indexPath]];
    RFAssert(cell, nil);
    [self.delegate tableView:tableView configureCell:cell forIndexPath:indexPath offscreenRendering:NO];
    return cell;
}

#pragma mark - Cell height update

- (void)updateCellHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self.cellHeightManager invalidateCellHeightCacheAtIndexPath:indexPath];
    [self beginUpdates];
    [self endUpdates];
}

- (void)updateCellHeightOfCell:(UITableViewCell *)cell {
    NSIndexPath *ip = [self indexPathForCell:cell];
    if (ip) {
        [self updateCellHeightAtIndexPath:ip];
    }
}

@end
