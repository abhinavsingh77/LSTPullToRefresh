//
//  MyRefreshView.h
//  PulltoRefreshSample
//
//  Created by Abhinav Singh on 08/04/16.
//

#import "LSTRefreshHeaderView.h"

@interface MyRefreshView : LSTRefreshHeaderView {
    
    __weak UILabel *percentageLabel;
    __weak UILabel *infoLabel;
}

-(void)setInfo:(NSString*)info;

@end
