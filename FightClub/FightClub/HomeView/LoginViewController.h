//
//  LoginViewController.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/26/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLoginFormTableTotalSections 2
#define kLoginFormTableUsernameSectionTotalRows 1
#define kLoginFormTablePasswordSectionTotalRows 1

#define kLoginFormTableUsernameSection 0
#define kLoginFormTablePasswordSection 1

@interface LoginViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, retain) UIView* mainView;
@property (nonatomic, retain) UIImageView* backgroundView;
@property (nonatomic, retain) UIView* separator;
@property (nonatomic, retain) UIImageView* avatar;
@property (nonatomic, retain) UITextField* username;
@property (nonatomic, retain) UITextField* password;
@property (nonatomic, retain) UIButton* loginBtn;
@property (nonatomic, retain) UIView* loginFieldBorder;

@property (nonatomic, assign) UITextField* activeTextField;

@end
