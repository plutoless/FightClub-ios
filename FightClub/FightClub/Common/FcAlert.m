//
//  FcAlert.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/27/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "FcAlert.h"

@implementation FcAlert

static FcAlert * alert;

- (id) init
{
    self = [super init];
    if (self != nil) {
        self.isShowing = NO;
        
        self.infoAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
    
    return self;
}

+ (FcAlert*) getInstance
{
    if (alert == nil) {
        alert  = [[FcAlert alloc] init];
    }
    
    return alert;
}

- (void) showInfoAlertwithTitle:(NSString *)title message:(NSString *)message
{
    if (self.infoAlert != nil && !self.isShowing) {
        [self.infoAlert setTitle:title];
        [self.infoAlert setMessage:message];
        [self.infoAlert show];
    }
}

#pragma UIAlertView Delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.infoAlert) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            [self.infoAlert dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
