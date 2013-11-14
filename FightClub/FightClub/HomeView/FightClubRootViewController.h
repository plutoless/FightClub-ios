//
//  FightClubRootViewController.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/24/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FightClubRootViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    BOOL needAnimate;
    BOOL isCreateShowing;
}

@property (nonatomic, retain) UIView* homeView;
@property (nonatomic, retain) NSMutableArray* tasks;
@property (nonatomic, retain) UITableView* tblView;
@property (nonatomic, retain) UIView* topView;
@property (nonatomic, retain) UITextField* createTaskField;
@property (nonatomic, retain) UIView* touchOverlay;

- (void) updateTasks:(NSMutableArray*)tasks;
@end
