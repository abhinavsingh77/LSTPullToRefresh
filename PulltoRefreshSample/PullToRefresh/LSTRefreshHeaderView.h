//
//  LSTRefreshHeaderView.h
//  TableRefresh
//
//  Created by Abhinav Singh on 19/05/14.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, RefreshViewState) {
    
	RefreshViewStateUnknown = -1,
	RefreshViewStateInitial = 0,
	RefreshViewStateReadyToStart,
	RefreshViewStateStarted,
};

typedef NS_ENUM (NSInteger, RefreshViewPosition) {
    
	RefreshViewPositionTop = 0,
	RefreshViewPositionBottom,
};

typedef void (^ StateChangeBlock)(RefreshViewState state);

@interface LSTRefreshHeaderView : UIView {
	
	NSInteger tableTopInset;
	NSInteger tableBottomInset;
	
	NSInteger myContentInset;
	CGSize tableContentSize;
	
	BOOL removingObserver;
}

@property(readonly, weak) UIScrollView *scrollView;
@property(readonly, assign) RefreshViewPosition position;
@property(nonatomic, assign) CGFloat progress;

@property(nonatomic, strong) StateChangeBlock stateChangeBlock;

@property(readonly, assign) RefreshViewState state;

-(instancetype)initWithHeight:(NSInteger)height andPosition:(RefreshViewPosition)position;
-(void)endRefreshing;
-(void)startRefreshing;

//Methods to override in subclass.
//Customize UI of your Refresh view Here.
- (void)loadUI;

//Callback of state change.
- (void)stateChangedTo:(RefreshViewState)state;

@end
