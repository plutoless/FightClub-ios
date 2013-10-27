//
//  FcAlert.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/27/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FcAlert : NSObject<UIAlertViewDelegate>

+ (FcAlert*) getInstance;
- (void) showInfoAlertwithTitle:(NSString*)title message:(NSString*)message;

@property (nonatomic, retain) UIAlertView* infoAlert;
@property (nonatomic, assign) BOOL isShowing;

@end
