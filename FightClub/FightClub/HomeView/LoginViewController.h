//
//  LoginViewController.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/26/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLoginFormTableTotalSections 2
#define kLoginFormTableInfoSectionTotalRows 2
#define kLoginFormTableLoginBtnSectionTotalRows 1

#define kLoginFormTableInfoSection 0
#define kLoginFormUsernameField 0
#define kLoginFormPasswordField 1

#define kLoginFormLoginBtnSection 1

@interface LoginViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, retain) UIView* mainView;
@property (nonatomic, retain) UIImageView* avatar;
@property (nonatomic, retain) UITextField* username;
@property (nonatomic, retain) UITextField* password;
@property (nonatomic, retain) UIButton* loginBtn;

@property (nonatomic, assign) UITextField* activeTextField;

@end
