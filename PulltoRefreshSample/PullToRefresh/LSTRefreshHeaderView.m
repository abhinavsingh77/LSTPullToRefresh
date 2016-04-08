//
//  LSTRefreshHeaderView.m
//  TableRefresh
//
//  Created by Abhinav Singh on 19/05/14.
//

#import "LSTRefreshHeaderView.h"

@interface LSTRefreshHeaderView ()

@property(nonatomic, assign) NSInteger reloadOffset;

@end

@implementation LSTRefreshHeaderView

- (instancetype)initWithHeight:(NSInteger)height andPosition:(RefreshViewPosition)position {
	
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
    if (self) {
		
		_position = position;
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
		self.translatesAutoresizingMaskIntoConstraints = YES;
        
		[self loadUI];
		
		_state = RefreshViewStateUnknown;
		self.state = RefreshViewStateInitial;
		
		removingObserver = NO;
    }
	
    return self;
}

- (void)removeFromTableView:(UIView*)table {

	if (removingObserver) {
		return;
	}
	
	removingObserver = YES;
	self.state = RefreshViewStateInitial;
	
	[table removeObserver:self forKeyPath:@"contentInset" context:nil];
	[table removeObserver:self forKeyPath:@"contentOffset" context:nil];
	[table removeObserver:self forKeyPath:@"contentSize" context:nil];
	
	_scrollView = nil;
	removingObserver = NO;
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
	
	if (self.superview) {
		[self removeFromTableView:self.superview];
	}
	
	[super willMoveToSuperview:newSuperview];
}

-(void)didMoveToSuperview {
	
	[super didMoveToSuperview];
	if (self.superview && [self.superview isKindOfClass:[UIScrollView class]]) {
		
		UIScrollView *tableView = (UIScrollView*)self.superview;
		
		myContentInset = self.frame.size.height;
		
		if (self.position == RefreshViewPositionTop) {
			self.frame = CGRectMake(0, -self.frame.size.height, tableView.frame.size.width, self.frame.size.height);
		}
		else {
			self.frame = CGRectMake(0, tableView.contentSize.height, tableView.frame.size.width, self.frame.size.height);
		}
		
		self.reloadOffset = self.frame.size.height;
		
		tableTopInset = tableView.contentInset.top;
		tableBottomInset = tableView.contentInset.bottom;
		tableContentSize = tableView.contentSize;
		
		[tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
		[tableView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
		[tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
		_scrollView = tableView;
	}
}

-(void)setReloadOffset:(NSInteger)reloadOffset {
	
	if (self.position == RefreshViewPositionTop) {
		_reloadOffset = -reloadOffset;
	}
	else {
		_reloadOffset = reloadOffset;
	}
}

- (void)endRefreshing {
	self.state = RefreshViewStateInitial;
}

- (void)startRefreshing {
	self.state = RefreshViewStateStarted;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	//Control is not already reloading;
	if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.state != RefreshViewStateStarted) {
            
            if ((self.state == RefreshViewStateReadyToStart) && !_scrollView.isTracking ) {
                
                self.state = RefreshViewStateStarted;
            }
            else if (self.scrollView.isTracking) {
                
                CGPoint nowPoint = [[change objectForKey:@"new"] CGPointValue];
                
                if (self.position == RefreshViewPositionTop) {
                    
                    CGFloat draggedPart = -(nowPoint.y+tableTopInset);
                    CGFloat progress = (draggedPart/self.frame.size.height);
                    self.progress = progress;
                }else {
                    
                    CGFloat draggedPart = (nowPoint.y+tableTopInset+_scrollView.frame.size.height);
                    int visiblePart = (draggedPart - (self.reloadOffset+tableContentSize.height+_scrollView.contentInset.top));
                    visiblePart += self.frame.size.height;
                    CGFloat progress = (visiblePart/self.frame.size.height);
                    
                    self.progress = progress;
                }
                
                if (self.position == RefreshViewPositionTop) {
                    
                    nowPoint.y += tableTopInset;
                    if (nowPoint.y < self.reloadOffset) {
                        self.state = RefreshViewStateReadyToStart;
                    }else {
                        self.state = RefreshViewStateInitial;
                    }
                }else {
                    
                    NSInteger tableHeight = _scrollView.frame.size.height;
                    nowPoint.y += (tableHeight+tableTopInset);
                    
                    NSInteger lastPoint = (self.reloadOffset+tableContentSize.height+_scrollView.contentInset.top);
                    
                    if ( (nowPoint.y > lastPoint) && (tableContentSize.height > 0)) {
                        self.state = RefreshViewStateReadyToStart;
                    }else {
                        self.state = RefreshViewStateInitial;
                    }
                }
            }
        }
	}
	else if ([keyPath isEqualToString:@"contentInset"]) {
		
		tableTopInset = _scrollView.contentInset.top;
		tableBottomInset = _scrollView.contentInset.bottom;
		
		if (self.state == RefreshViewStateStarted) {
			
			if (self.position == RefreshViewPositionTop) {
				tableTopInset -= myContentInset;
			}
			else {
				tableBottomInset -= myContentInset;
			}
		}
	}
	else if ([keyPath isEqualToString:@"contentSize"]) {
		if (self.position == RefreshViewPositionBottom) {
			
			CGSize size = [[change objectForKey:@"new"] CGSizeValue];
			tableContentSize = size;
            
			if ( self.state != RefreshViewStateStarted) {
                
				self.frame = CGRectMake(0, tableContentSize.height, tableContentSize.width, self.frame.size.height);
			}
		}
	}
}

-(void)setState:(RefreshViewState)state {
	
	if (self.state != state) {
		
		_state = state;
		
		if (self.stateChangeBlock) {
			self.stateChangeBlock(state);
		}
		[self stateChangedTo:self.state];
	}
}

-(void)setStateChangeBlock:(StateChangeBlock)stateChangeBlock {
	
	if (stateChangeBlock) {
		stateChangeBlock(self.state);
	}
	
	_stateChangeBlock = stateChangeBlock;
}

#pragma mark - Methods Which can be Override in Subclass.

-(void)setProgress:(CGFloat)progress {
	
	_progress = progress;
}

- (void)stateChangedTo:(RefreshViewState)state {
	
	switch (state) {
		case RefreshViewStateInitial: {
            
			[UIView animateWithDuration:0.3 animations:^{
				if (self.position == RefreshViewPositionTop) {
					_scrollView.contentInset = UIEdgeInsetsMake( tableTopInset, 0, tableBottomInset, 0);
				}else {
					_scrollView.contentInset = UIEdgeInsetsMake( tableTopInset, 0, tableBottomInset, 0);
				}
			} completion:nil];
		}
		break;
		case RefreshViewStateStarted: {
			
			[UIView animateWithDuration:0.3 animations:^{
				if (self.position == RefreshViewPositionTop) {
					_scrollView.contentInset = UIEdgeInsetsMake( tableTopInset+myContentInset, 0, 0, 0);
				}else {
					_scrollView.contentInset = UIEdgeInsetsMake( tableTopInset, 0, tableBottomInset+myContentInset, 0);
				}
			} completion:nil];
		}
		break;
		case RefreshViewStateReadyToStart: {
			break;
		}
		default: {
			NSLog(@"This Shouldn't happen!!!!");
		}
		break;
	}
}

- (void)loadUI {
	
}

@end
