
#import "EntityList.h"
#import "EntityDetailViewController.h"
#import "RFPullToFetchTableView.h"
#import "API.h"

@interface EntityList ()
@property (retain, nonatomic) RFPullToFetchTableView *tableView;
@property (strong, nonatomic) UILabel *footerView;
@property (strong, nonatomic) UILabel *headerView;

@property (strong, nonatomic) NSMutableArray *tableData;
@end

@implementation EntityList
RFUIInterfaceOrientationSupportAll

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableData = [NSMutableArray array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.footerView = (UILabel *)self.tableView.tableFooterView;
    self.tableView.tableFooterView = nil;
    
    self.tableView.footerContainer = self.footerView;
    [self.tableView addSubview:self.footerView];
    
    self.headerView = (UILabel *)self.tableView.tableHeaderView;
    self.tableView.tableHeaderView = nil;
    
    self.tableView.headerContainer = self.headerView;
    [self.tableView addSubview:self.headerView];
    
    [self setupPullToFetchTable];
    [self.tableView triggerHeaderProccess];
}

- (void)reloadPages {
    self.currentPage = 1;
    self.reachEnd = NO;
    
//    [[API sharedInstance] fetchEntityWithSomething:something page:self.currentPage completion:^(NSArray *entities, NSError *error) {
//        [self.tableView headerProccessFinshed];
//        
//        self.headerView.text = nil;
//        
//        if (error) {
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//            return;
//        }
//        
//        [self.tableData removeAllObjects];
//        [self.tableData addObjectsFromArray:entities];
//        [self.tableView reloadData];
//        if (entities.count < APIConfigFetchPageSize) {
//            self.reachEnd = YES;
//        }
//    }];
}

- (void)loadNextPage {
    if (self.tableView.isFetching || self.reachEnd) {
        [self.tableView footerProccessFinshed];
        return;
    }
    
//    [[API sharedInstance] fetchEntityWithSomething:something page:self.currentPage+1 completion:^(NSArray *entities, NSError *error) {
//        [self.tableView footerProccessFinshed];
//        
//        self.footerView.text = nil;
//        
//        if (error) {
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//            return;
//        }
//        
//        self.currentPage++;
//        [self.tableData addObjectsFromArray:entities];
//        [self.tableView reloadData];
//        if (entities.count < APIConfigFetchPageSize) {
//            self.reachEnd = YES;
//        }
//    }];
}

- (void)setReachEnd:(BOOL)reachEnd {
    if (_reachEnd != reachEnd) {
        if (reachEnd) {
            self.footerView.text = @"没有更多了";
            self.tableView.footerFetchingEnabled = NO;
            [self.tableView setFooterContainerVisible:YES animated:YES];
        }
        else {
            self.footerView.text = nil;
            self.tableView.footerFetchingEnabled = YES;
        }
        _reachEnd = reachEnd;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EntityListCell *cell = (EntityListCell *)sender;
    if ([cell isKindOfClass:[EntityListCell class]]) {
        [(EntityDetailViewController *)segue.destinationViewController setEntity:cell.entity];
    }
}

#pragma mark - Table
- (void)setupPullToFetchTable {
    
    @weakify(self);
    [self.tableView setHeaderVisibleChangeBlock:^(BOOL isVisible, CGFloat visibleHeight, BOOL isCompleteVisible, BOOL isProccessing) {
        @strongify(self)
        if (self.reachEnd) return;
        
        if (isProccessing) {
            self.headerView.text = @"正在刷新……";
            return;
        }
        
        if (isCompleteVisible) {
            self.headerView.text = @"释放刷新";
            return;
        }
        
        if (isVisible) {
            self.headerView.text = @"继续上拉以刷新";
        }
    }];
    
    [self.tableView setFooterVisibleChangeBlock:^(BOOL isVisible, CGFloat visibleHeight, BOOL isCompleteVisible, BOOL isProccessing) {
        @strongify(self)
        if (self.reachEnd) return;
        
        if (isProccessing) {
            self.footerView.text = @"正在加载……";
            return;
        }
        
        if (isCompleteVisible) {
            self.footerView.text = @"释放加载更多";
            return;
        }
        
        if (isVisible) {
            self.footerView.text = @"继续上拉以加载更多";
        }
    }];
    
    [self.tableView setFooterProccessBlock:^{
        @strongify(self);
        [self loadNextPage];
    }];
    
    [self.tableView setHeaderProccessBlock:^{
        @strongify(self);
        [self reloadPages];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EntityListCell *cell = [self.tableView dequeueReusableCellWithClass:[EntityListCell class]];
    cell.entity = (Entity *)[self.tableData objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

@end

@implementation EntityListCell

- (void)setEntity:(Entity *)entity {
    _entity = entity;
    
    // Do something
}


@end
