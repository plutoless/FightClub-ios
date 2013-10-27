//
//  BusyIndicator.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/27/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "BusyIndicator.h"

@interface BusyIndicator ()

@end

@implementation BusyIndicator

static BusyIndicator* busyIndicator;

- (id) init
{
    self = [super init];
    if (self != nil) {
        CGRect frame = [[UIScreen mainScreen] bounds];
        UIView *modalView = [[UIView alloc] initWithFrame:frame];
        
        [modalView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
        
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGRect indicatorFrame = indicator.frame;
        
        [indicator setFrame:CGRectMake(frame.size.width/2 - indicatorFrame.size.width/2, frame.size.height/2 - indicatorFrame.size.height/2, indicatorFrame.size.width, indicatorFrame.size.height)];
        [modalView addSubview:indicator];
        
        self.view = modalView;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (BusyIndicator*)getInstance
{
    if (busyIndicator == nil) {
        busyIndicator = [[BusyIndicator alloc] init];
    }
    
    return busyIndicator;
}

@end
