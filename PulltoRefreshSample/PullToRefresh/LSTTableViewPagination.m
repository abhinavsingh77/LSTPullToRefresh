//
//  LSTTableViewPagination.m
//  PulltoRefreshSample
//
//  Created by Abhinav Singh on 08/04/16.
//

#import "LSTTableViewPagination.h"

@implementation LSTTableViewPagination

- (instancetype)initWithTableView:(UITableView*)table pageSize:(NSInteger)pSize startPageNumber:(NSInteger)spNum{
    
    self = [super init];
    if (self) {
        
        table.delegate = self;
        table.dataSource = self;
        
        _dataTableView = table;
        
        _dataArray = [NSMutableArray new];
        
        _expectedNextPageNumber = NSNotFound;
        _totalResultsAvaliable = 0;
        _currentPageNumber = -1;
        
        _paginationPageSize = pSize;
        _paginationStartPageNumber = spNum;
    }
    
    return self;
}

-(void)downloadResultForPage:(NSInteger)page {
    
    __weak LSTTableViewPagination *weakSelf = self;
    
    if ([self.delegate respondsToSelector:@selector(showEmptyState:paginationObject:)]) {
        [self.delegate showEmptyState:NO paginationObject:self];
    }
    
    if ((pullToRefreshView.state != RefreshViewStateStarted) && (pullToRefreshView.state != RefreshViewStateStarted)) {
        
        if ([self.delegate respondsToSelector:@selector(showLoadingView:)]) {
            [self.delegate showLoadingView:self];
        }
    }
    
    [self.delegate downloadResultForPage:page paginationObject:self completion:^(NSArray *result, NSInteger total) {
        
        [weakSelf addMediaArray:result forPageNumber:page totalFound:total];
        
        if ([weakSelf.delegate respondsToSelector:@selector(removeLoadingView:)]) {
            [weakSelf.delegate removeLoadingView:self];
        }
    }];
}

-(void)addMediaArray:(NSArray*)newData forPageNumber:(NSInteger)pageNum totalFound:(NSInteger)total{
    
    BOOL canLoadMore = NO;
    NSInteger newCount = newData.count;
    
    NSInteger beforeCount = 0;
    if (newCount) {
        
        canLoadMore = YES;
        
        _currentPageNumber = pageNum;
        
        if (pageNum <= self.paginationStartPageNumber) {
            [self.dataArray removeAllObjects];
        }
        
        beforeCount = self.dataArray.count;
        
        [self.dataArray addObjectsFromArray:newData];
        
        if ( newCount < self.paginationPageSize ) {
            canLoadMore = NO;
        }
    }else if (pageNum == self.paginationStartPageNumber) {
        
        [self.dataArray removeAllObjects];
        canLoadMore = NO;
    }
    
    if (!canLoadMore) {
        _expectedNextPageNumber = NSNotFound;
    }else {
        _expectedNextPageNumber = (pageNum+1);
    }
    
    [self changeLoadMoreInfoForTotal:total];
    
    [pullToLoadMoreView endRefreshing];
    [pullToRefreshView endRefreshing];
    
    NSInteger newCellsCount = (self.dataArray.count - beforeCount);
    if ( (newCellsCount > 0) && (beforeCount > 0) ) {
        
        NSMutableArray *newIndexPaths = [NSMutableArray new];
        for ( int row = 0; row < newCellsCount; row++ ) {
            [newIndexPaths addObject:[NSIndexPath indexPathForRow:(beforeCount+row) inSection:0]];
        }
        
        [self.dataTableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    }else {
        
        [self.dataTableView reloadData];
    }
    
    BOOL empty = NO;
    if (!self.dataArray.count) {
        empty = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(showEmptyState:paginationObject:)]) {
        [self.delegate showEmptyState:empty paginationObject:self];
    }
}

#pragma mark UITableViewDelegate & UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSException exceptionWithName:@"Subclass Required Method Missing!!" reason:[NSString stringWithFormat:@"Subclass Must Implement %s", __PRETTY_FUNCTION__] userInfo:nil] raise];
    
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //this must be one.
    //This class handle only one section.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = self.dataArray.count;
    
    if ([self canShowLoadMoreFooter]) {
        [self addFooterRefreshView];
    }else {
        [self removeFooterRefreshView];
    }
    
    return count;
}

#pragma mark LoadMore + Pull To Refresh

-(void)changeLoadMoreInfoForTotal:(NSInteger)total {
    
    _totalResultsAvaliable = total;
}

-(Class)refreshViewClass {
    return [LSTRefreshHeaderView class];
}

-(BOOL)canShowLoadMoreFooter {
    
    if ( (self.dataArray.count < self.paginationPageSize) || (self.expectedNextPageNumber == NSNotFound) ) {
        return NO;
    }else {
        return YES;
    }
}

- (void)removeFooterRefreshView {
    
    [pullToLoadMoreView removeFromSuperview];
    pullToLoadMoreView = nil;
}

-(void)addPullToRefresh {
    
    if (!pullToRefreshView) {
        
        LSTRefreshHeaderView *refresh = [[[self refreshViewClass] alloc] initWithHeight:100 andPosition:RefreshViewPositionTop];
        [self.dataTableView addSubview:refresh];
        
        pullToRefreshView = refresh;
        
        __weak LSTTableViewPagination *blockSelf = self;
        [pullToRefreshView setStateChangeBlock:^(RefreshViewState newState) {
            
            if (newState == RefreshViewStateStarted) {
                
                [blockSelf refreshDataFromServer];
            }
        }];
    }
}

- (void)addFooterRefreshView {
    
    if (!pullToLoadMoreView) {
        
        LSTRefreshHeaderView *loadMore = [[[self refreshViewClass] alloc] initWithHeight:100 andPosition:RefreshViewPositionBottom];
        [self.dataTableView addSubview:loadMore];
        
        pullToLoadMoreView = loadMore;
        
        [self changeLoadMoreInfoForTotal:self.totalResultsAvaliable];
        
        __weak LSTTableViewPagination *blockSelf = self;
        [pullToLoadMoreView setStateChangeBlock:^(RefreshViewState newState) {
            
            if (newState == RefreshViewStateStarted) {
                
                [blockSelf loadResultsForNextPageNum];
            }
        }];
    }
}

-(void)refreshDataFromServer {
    
    [self downloadResultForPage:self.paginationStartPageNumber];
}

-(void)loadResultsForNextPageNum {
    
    [self downloadResultForPage:self.expectedNextPageNumber];
}

@end
