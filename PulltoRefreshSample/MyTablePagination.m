//
//  MyTablePagination.m
//  PulltoRefreshSample
//
//  Created by Abhinav Singh on 08/04/16.
//

#import "MyTablePagination.h"
#import "MyRefreshView.h"

@implementation MyTablePagination

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *data = self.dataArray[indexPath.row];
    cell.textLabel.text = data;
}

-(void)changeLoadMoreInfoForTotal:(NSInteger)total {
    
    [super changeLoadMoreInfoForTotal:total];
    [(MyRefreshView*)pullToLoadMoreView setInfo:[NSString stringWithFormat:@"Showing %@ Out of %@", @(self.dataArray.count), @(self.totalResultsAvaliable)]];
}

-(Class)refreshViewClass {
    
    return [MyRefreshView class];
}

@end
