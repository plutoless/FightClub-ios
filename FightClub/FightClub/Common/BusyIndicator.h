//
//  BusyIndicator.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/27/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusyIndicator : UIViewController

@property (nonatomic, retain) UIActivityIndicatorView* indicator;

+ (BusyIndicator*) getInstance;

- (void)showFromController:(UIViewController*)fromController;
- (void)dismissFromController:(UIViewController*)fromController;

@end
