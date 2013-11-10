//
//  FightClubRootViewController.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/24/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FightClubRootViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    BOOL isUpdating;
    BOOL isCreateShowing;
}

@property (nonatomic, retain) UIView* homeView;
@property (nonatomic, retain) NSArray* tasks;
@property (nonatomic, retain) UITableView* tblView;
@property (nonatomic, retain) UIView* topView;
@property (nonatomic, retain) UITextField* createTaskField;
@property (nonatomic, retain) UIView* touchOverlay;

- (void) updateTasks:(NSArray*)tasks;
@end
