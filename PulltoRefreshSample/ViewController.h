//
//  ViewController.h
//  PulltoRefreshSample
//
//  Created by Abhinav Singh on 08/04/16.
//

#import <UIKit/UIKit.h>
#import "MyTablePagination.h"

@interface ViewController : UIViewController <LSTTableViewPaginationDelegate>{
    
    MyTablePagination *myPagination;
    __weak IBOutlet UITableView *theTableView;
}

@end

