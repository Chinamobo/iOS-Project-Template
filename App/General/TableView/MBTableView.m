
#import "MBTableView.h"
#import "API.h"

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

    MBTableViewPullToFetchControl *control = self.pullToFetchController;

    @weakify(self);
    [control setHeaderProcessBlock:^{
        @strongify(self);
        [self fetchItemsWithPageFlag:NO];
    }];

    [control setFooterProcessBlock:^{
        @strongify(self);
        [self fetchItemsWithPageFlag:YES];
    }];
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
        _pullToFetchController = [[MBTableViewPullToFetchControl alloc] init];
        _pullToFetchController.tableView = self;
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

@end
