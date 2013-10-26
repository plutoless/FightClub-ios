//
//  LoginViewController.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/26/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "LoginViewController.h"
#import "FcConstant.h"
#import "SecManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGRect frame = [[UIScreen mainScreen] bounds];
        self.mainView = [[UIView alloc] initWithFrame:frame];
        [self.mainView setBackgroundColor:[UIColor colorWithRed:0.35 green:0.70 blue:0.87 alpha:1]];
//        UIImageView *bgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        UIImage *bgImg = [UIImage imageNamed:@"login.jpg"];
//        [bgView setImage:bgImg];
//        [bgView setContentMode:UIViewContentModeRight];
//        [bgView setContentScaleFactor:1.8];
//        [self.mainView addSubview:bgView];
        
        [self createContent];
        
        UITableView* form = [[UITableView alloc] initWithFrame:CGRectMake(0, frame.size.height/2 - 50, frame.size.width, LOGIN_FORM_TABLE_HEIGHT) style:UITableViewStyleGrouped];
        form.delegate = self;
        form.dataSource = self;
        form.scrollEnabled = NO;
        
        [form setBackgroundColor:[UIColor clearColor]];
        
        [self.mainView addSubview:form];
        
        self.view = self.mainView;
        
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [self.mainView addGestureRecognizer:tap];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) createContent
{
    CGRect frame = self.mainView.frame;
    self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-LOGIN_FORM_AVATAR_HEIGHT/2, frame.size.height/2 -200, LOGIN_FORM_AVATAR_HEIGHT, LOGIN_FORM_AVATAR_HEIGHT)];
    UIImage *avatarImg = [UIImage imageNamed:@"21.png"];
    [self.avatar setImage:avatarImg];
    [self.avatar.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.avatar.layer setShadowOpacity:0.5];
    [self.avatar.layer setShadowColor:[UIColor colorWithWhite:0.4 alpha:1].CGColor];
    
    [self.mainView addSubview:self.avatar];
    
    self.username = [[UITextField alloc] initWithFrame:CGRectMake(LOGIN_FORM_CELL_FIELD_PADDING, 0, frame.size.width - LOGIN_FORM_CELL_FIELD_PADDING * 2, LOGIN_FORM_CELL_HEIGHT)];
    [self.username setPlaceholder:@"Username"];
    self.username.delegate = self;
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(LOGIN_FORM_CELL_FIELD_PADDING, 0, frame.size.width - LOGIN_FORM_CELL_FIELD_PADDING *2, LOGIN_FORM_CELL_HEIGHT)];
    [self.password setPlaceholder:@"Password"];
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(0, 0, frame.size.width, LOGIN_FORM_CELL_HEIGHT);
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:0.8 green:0.4 blue:0.4 alpha:1]];
    [self.loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginBtn setEnabled:YES];
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}

- (void) dismissKeyboard
{
    if (self.activeTextField != nil) {
        [self.activeTextField resignFirstResponder];
    }
}

- (void) login
{
}

#pragma UITableViewDelegate UITableDatasource functions
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (section) {
        case kLoginFormTableInfoSection:
            num = kLoginFormTableInfoSectionTotalRows;
            break;
        case kLoginFormLoginBtnSection:
            num = kLoginFormTableLoginBtnSectionTotalRows;
            break;
        default:
            break;
    }
    
    return num;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return kLoginFormTableTotalSections;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LOGIN_FORM_CELL_HEIGHT;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == kLoginFormTableInfoSection) {
        switch (indexPath.row) {
            case kLoginFormUsernameField:
                [cell addSubview:self.username];
                break;
            case kLoginFormPasswordField:
                [cell addSubview:self.password];
                break;
            default:
                break;
        }
    } else if (indexPath.section == kLoginFormLoginBtnSection){
        [cell addSubview:self.loginBtn];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.activeTextField == self.username) {
        [self.password becomeFirstResponder];
    } else if (self.activeTextField == self.password){
        [self dismissKeyboard];
    }
    
    return YES;
}

@end
