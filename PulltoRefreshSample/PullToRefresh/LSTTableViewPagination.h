//
//  LSTTableViewPagination.h
//  PulltoRefreshSample
//
//  Created by Abhinav Singh on 08/04/16.
//

@import Foundation;
@import UIKit;

#import "LSTRefreshHeaderView.h"

typedef void (^ LSTPaginationResultBlock)( NSArray *result, NSInteger totalResultsAvaliable );

@class LSTTableViewPagination;

@protocol LSTTableViewPaginationDelegate <NSObject>

-(void)downloadResultForPage:(NSInteger)page paginationObject:(LSTTableViewPagination*)pagination
                  completion:(LSTPaginationResultBlock)block;

@optional

-(void)showEmptyState:(BOOL)empty paginationObject:(LSTTableViewPagination*)pagination;
-(void)showLoadingView:(LSTTableViewPagination*)pagination;
-(void)removeLoadingView:(LSTTableViewPagination*)pagination;

@end

@interface LSTTableViewPagination : NSObject <UITableViewDataSource, UITableViewDelegate> {
    
    __weak LSTRefreshHeaderView *pullToRefreshView;
    __weak LSTRefreshHeaderView *pullToLoadMoreView;
}

-(instancetype)initWithTableView:(UITableView*)table pageSize:(NSInteger)pSize startPageNumber:(NSInteger)spNum;

-(Class)refreshViewClass;

@property(nonatomic, weak) id <LSTTableViewPaginationDelegate> delegate;
@property(readonly, weak) UITableView *dataTableView;

@property(readonly, strong) NSMutableArray *dataArray;

@property(readonly, assign) NSInteger totalResultsAvaliable;
@property(readonly, assign) NSInteger currentPageNumber;
@property(readonly, assign) NSInteger expectedNextPageNumber;

@property(readonly, assign) NSInteger paginationPageSize;
@property(readonly, assign) NSInteger paginationStartPageNumber;

-(void)addPullToRefresh;

-(void)downloadResultForPage:(NSInteger)page;
-(void)changeLoadMoreInfoForTotal:(NSInteger)total;

@end
