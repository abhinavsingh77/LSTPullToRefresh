//
//  MyRefreshView.m
//  PulltoRefreshSample
//
//  Created by Abhinav Singh on 08/04/16.
//

#import "MyRefreshView.h"

@implementation MyRefreshView

-(void)loadUI {
    
    [super loadUI];
    
    UILabel *plabel = [[UILabel alloc] initWithFrame:CGRectZero];
    plabel.textAlignment = NSTextAlignmentCenter;
    plabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:plabel];
    
    UILabel *ilabel = [[UILabel alloc] initWithFrame:CGRectZero];
    ilabel.textAlignment = NSTextAlignmentCenter;
    ilabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:ilabel];
    
    infoLabel = ilabel;
    percentageLabel = plabel;
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(infoLabel, percentageLabel);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[percentageLabel]-0-|" options:0 metrics:nil views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[infoLabel]-0-|" options:0 metrics:nil views:dict]];
    
    if (self.position == RefreshViewPositionTop) {
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[infoLabel]-5-[percentageLabel]-5-|" options:0 metrics:nil views:dict]];
    }
    else if (self.position == RefreshViewPositionBottom) {
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[infoLabel]-5-[percentageLabel]" options:0 metrics:nil views:dict]];
    }
}

-(void)setInfo:(NSString*)info {
    
    [infoLabel setText:info];
}

-(void)setProgress:(CGFloat)progress{
    
    [super setProgress:progress];
    
    if (progress < 0) {
        progress = 0;
    }
    
    percentageLabel.text = [NSString stringWithFormat:@"%d %%", (int)(progress*100)];
}

@end
