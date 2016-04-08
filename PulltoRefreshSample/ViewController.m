//
//  ViewController.m
//  PulltoRefreshSample
//
//  Created by Abhinav Singh on 08/04/16.
//

#import "ViewController.h"

@interface ViewController () {
    
    NSMutableArray *dummyDataArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    dummyDataArray = [NSMutableArray new];
    
    for ( int i = 0; i < 2000; i++ ) {
        
        [dummyDataArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    NSInteger startPage = 1;
    
    myPagination = [[MyTablePagination alloc] initWithTableView:theTableView pageSize:20 startPageNumber:startPage];
    myPagination.delegate = self;
    [myPagination downloadResultForPage:startPage];
    [myPagination addPullToRefresh];
}

-(void)downloadResultForPage:(NSInteger)page paginationObject:(LSTTableViewPagination*)pagination
                  completion:(LSTPaginationResultBlock)block {
    
    NSRange dataRange = NSMakeRange((page-pagination.paginationStartPageNumber)*pagination.paginationPageSize, pagination.paginationPageSize);
    NSArray *dataA = [dummyDataArray subarrayWithRange:dataRange];
    
    if (block) {
        block(dataA, dummyDataArray.count);
    }
}

@end
