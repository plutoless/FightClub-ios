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
#import "FcAlert.h"
#import "BusyIndicator.h"
#import "LoginOperation.h"
#import "BaseHttpOperation.h"
#import "FightClubRootViewController.h"
#import "Utils.h"
#import "FcDatabase.h"
#import "AppDelegate.h"

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
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        [self.mainView setBackgroundColor:FC_THEME_BG_COLOR];
        self.backgroundView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIImage *bgImg = [UIImage imageNamed:@"login_bg"];
        [self.backgroundView setImage:bgImg];
        [self.backgroundView setContentMode:UIViewContentModeRight];
        [self.backgroundView setContentScaleFactor:1.8];
        [self.mainView addSubview:self.backgroundView];
        
        [self createContent];
        [self createLoginForm];
        self.view = self.mainView;
        
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [self.mainView addGestureRecognizer:tap];
        
//        [self performSelector:@selector(loginFromLaunch) withObject:self afterDelay:0.4];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self.navigationItem setTitleView:[[Utils getFcAppDelegate] fcTitleLabelView]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) createLoginForm
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    UITableView* form = [[UITableView alloc] initWithFrame:CGRectMake(LOGIN_FORM_MARGIN_LEFT, LOGIN_FORM_TOP_OFFSET, frame.size.width - LOGIN_FORM_MARGIN_LEFT - LOGIN_FORM_MARGIN_RIGHT, LOGIN_FORM_CELL_HEIGHT*2) style:UITableViewStylePlain];
    form.delegate = self;
    form.dataSource = self;
    [form setScrollEnabled:NO];
    [form setBounces:NO];
    
    form.separatorStyle = UITableViewCellSeparatorStyleNone;
    form.sectionFooterHeight = 0.0;
    form.sectionHeaderHeight = 0.0;
    [form setBackgroundColor:[UIColor clearColor]];
    form.layer.cornerRadius = 5;
    
    [self.mainView addSubview:form];
}

- (void) createContent
{
    CGRect frame = self.mainView.frame;
//    self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-LOGIN_FORM_AVATAR_HEIGHT/2, frame.size.height/2 -200, LOGIN_FORM_AVATAR_HEIGHT, LOGIN_FORM_AVATAR_HEIGHT)];
//    UIImage *avatarImg = [UIImage imageNamed:@"21.png"];
//    [self.avatar setImage:avatarImg];
//    [self.avatar.layer setShadowOffset:CGSizeMake(0, 0)];
//    [self.avatar.layer setShadowOpacity:0.5];
//    [self.avatar.layer setShadowColor:[UIColor colorWithWhite:0.4 alpha:1].CGColor];
//    
//    [self.mainView addSubview:self.avatar];
    
    
    
    self.username = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, frame.size.width - LOGIN_FORM_MARGIN_LEFT - LOGIN_FORM_MARGIN_RIGHT, LOGIN_FORM_CELL_FD_HEIGHT)];
    NSAttributedString* userPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: FC_COLOR_WHITE_TRANS}];
    [self.username setAttributedPlaceholder:userPlaceholder];
    [self.username setFont:[UIFont fontWithName:@"MankSans" size:24]];
    [self.username setTextColor:FC_COLOR_WHITE];
    self.username.textAlignment = NSTextAlignmentCenter;
    self.username.layer.borderWidth = 1.0;
    self.username.layer.borderColor = FC_COLOR_WHITE.CGColor;
    self.username.delegate = self;
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, frame.size.width - LOGIN_FORM_MARGIN_LEFT - LOGIN_FORM_MARGIN_RIGHT, LOGIN_FORM_CELL_FD_HEIGHT)];
    NSAttributedString* passPlaceHolder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: FC_COLOR_WHITE_TRANS}];
    [self.password setAttributedPlaceholder:passPlaceHolder];
    [self.password setFont:[UIFont fontWithName:@"MankSans" size:24]];
    [self.password setTextColor:FC_COLOR_WHITE];
    self.password.textAlignment = NSTextAlignmentCenter;
    self.password.layer.borderWidth = 1.0;
    self.password.layer.borderColor = FC_COLOR_WHITE.CGColor;
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(LOGIN_FORM_MARGIN_LEFT, LOGIN_FORM_TOP_OFFSET + LOGIN_FORM_CELL_HEIGHT*2 + 5, frame.size.width - LOGIN_FORM_MARGIN_LEFT - LOGIN_FORM_MARGIN_RIGHT, LOGIN_FORM_CELL_FD_HEIGHT);
    [self.loginBtn setBackgroundImage:[Utils createImageByColor:self.loginBtn.frame color:FC_COLOR_WHITE cornerRadius:0] forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"LOG IN" forState:UIControlStateNormal];
    [[self.loginBtn titleLabel] setFont:[UIFont systemFontOfSize:16]];
    [self.loginBtn setTitleColor:FC_COLOR_DARK_RED forState:UIControlStateNormal];
    [self.loginBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginBtn setEnabled:YES];
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainView addSubview:self.loginBtn];
    
    self.separator = [[UIView alloc] initWithFrame:CGRectMake(0, LOGIN_FORM_CELL_HEIGHT-1, frame.size.width, 1)];
    [self.separator setBackgroundColor:FC_THEME_DARK_TEXT_COLOR];
    
    
//    self.loginFieldBorder = [[UIView alloc] initWithFrame:self.username.frame];
//    self.loginFieldBorder.layer.borderColor = FC_COLOR_WHITE.CGColor;
//    self.loginFieldBorder.layer.borderWidth = 1.0;
}

- (void) dismissKeyboard
{
    if (self.activeTextField != nil) {
        [self.activeTextField resignFirstResponder];
    }
}

- (BOOL) validateLoginInfo
{
    if ([[self.username text] isEqualToString:@""] || [[self.password text] isEqualToString:@""]) {
        [[FcAlert getInstance] showInfoAlertwithTitle:@"Error" message:@"Please fill in all required fields"];
        return NO;
    }
    
    
    return YES;
}

- (void) login
{
    if (![self validateLoginInfo]) {
        return;
    }
    
    SecManager * manager = [SecManager getInstance];
    [[manager secAttributes] setObject:[self.username text] forKey:SEC_ATTR_TEMP_USER];
    [[manager secAttributes] setObject:[self.password text] forKey:SEC_ATTR_TEMP_PASS];
    
    [[BusyIndicator getInstance] showFromController:self];
    LoginOperation* operation = [[LoginOperation alloc] initWithObject:self target:@selector(didFinishLoginWith:)];
    [operation start];
}

- (void) didFinishLoginWith:(NSDictionary*)Response
{
    BOOL valid = [[Response valueForKey:LOGIN_RESPONSE_STATUS] boolValue];
    if (!valid) {
        [[BusyIndicator getInstance] dismissFromController:self];
        [[FcAlert getInstance] showInfoAlertwithTitle:@"Error" message:@"Login Failed. Please check your username and password."];
    } else {
        NSNumber *uid = [[Response valueForKey:LOGIN_RESPONSE_DATA] valueForKey:LOGIN_RESPONSE_DATA_UID];
        NSString *uidStr = [NSString stringWithFormat:@"%@", uid];
        [[[SecManager getInstance] secAttributes] setValue:uidStr forKey:SEC_ATTR_UID];
        
        
        BaseHttpOperation* operation = [[BaseHttpOperation alloc] initWithObject:self target:@selector(didFinishLoadingTaskList:) type:FC_SERVICE_TYPE_GET_USER_TASK];
        [operation start];
        
    }
}

- (void) didFinishLoadingTaskList:(NSArray*)Response
{
    FightClubRootViewController* homeview = [[Utils getFcAppDelegate] homeViewController];
    
    [[BusyIndicator getInstance] dismissFromController:self];
    
    NSMutableArray* sortedTasks = [[NSMutableArray alloc] initWithArray:[Utils sortTasks:Response]];
    [homeview setTasks:sortedTasks];
    [[FcDatabase getInstance] insertTasks:sortedTasks willDelete:YES];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:[[SecManager getInstance] secAttributes]] ;
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:SEC_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController pushViewController:homeview animated:YES];
}

#pragma UITableViewDelegate UITableDatasource functions
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    [cell setBackgroundColor:FC_COLOR_TRANSPARENT];
    switch (indexPath.section) {
        case kLoginFormTableUsernameSection:
            [cell addSubview:self.username];
            break;
        case kLoginFormTablePasswordSection:
            [cell addSubview:self.password];
            break;
        default:
            break;
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
        [self login];
    }
    
    return YES;
}

@end
