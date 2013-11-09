//
//  FightClubRootViewController.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/24/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "FightClubRootViewController.h"
#import "FcConstant.h"
#import "LoginViewController.h"
#import "Utils.h"
#import "CreateTaskViewController.h"

#define TASK_LIST_TABLE_PADDING_X 10

@interface FightClubRootViewController ()

@end


@implementation FightClubRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isUpdating = NO;
        isCreateShowing = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        CGRect screenFrame = [[UIScreen mainScreen] bounds];
        // Custom initialization
        self.homeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width, screenFrame.size.height)];
        self.tasks = [[NSArray alloc] init];
//        UIImageView *bgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        UIImage *bgImg = [UIImage imageNamed:@"login.jpg"];
//        [bgView setImage:bgImg];
//        [bgView setContentMode:UIViewContentModeRight];
//        [bgView setContentScaleFactor:1.8];
        
//        [self.homeView addSubview:bgView];
        [self.homeView setBackgroundColor:FC_COLOR_WHITE];
        
        self.tblView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width, screenFrame.size.height) style:UITableViewStylePlain];
        self.tblView.dataSource = self;
        self.tblView.delegate = self;
        [self.tblView setBackgroundColor:[UIColor clearColor]];
        self.tblView.sectionFooterHeight = 0.0;
        self.tblView.sectionHeaderHeight = 0.0;
        self.tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UITextField* createTask = [[UITextField alloc] initWithFrame:CGRectMake(0, -TASK_LIST_CREATE_TASK_HEIGHT, screenFrame.size.width - TASK_LIST_CREATE_TASK_BTN_WIDTH, TASK_LIST_CREATE_TASK_HEIGHT)];
        [createTask setPlaceholder:@"Buy me a milk"];
        UIButton * createTaskBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [createTaskBtn setFrame:CGRectMake(screenFrame.size.width - TASK_LIST_CREATE_TASK_BTN_WIDTH, -TASK_LIST_CREATE_TASK_HEIGHT, TASK_LIST_CREATE_TASK_BTN_WIDTH, TASK_LIST_CREATE_TASK_HEIGHT)];
        [createTaskBtn setTitle:@"Done" forState:UIControlStateNormal];
        [self.tblView addSubview:createTask];
        [self.tblView addSubview:createTaskBtn];
        
        [self.homeView addSubview:self.tblView];
        
        self.view = self.homeView;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setTitle:@"TASKS"];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void) updateTasks:(NSArray*)tasks
{
    isUpdating = YES;
    [self setTasks:tasks];
    [[self tblView] reloadData];
}

- (void) showCreateTask
{
    [self.tblView setContentInset:UIEdgeInsetsMake(TASK_LIST_CREATE_TASK_HEIGHT, 0, 0, 0)];
    isCreateShowing = YES;
}

- (void) hideCreateTask
{
    [self.tblView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    isCreateShowing = NO;
}

#pragma UITableViewDelegate UITableDatasource functions
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.tasks objectAtIndex:section] count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tasks count];
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text = [[[self.tasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:TASK_ATTR_CONTENT];
    cell.textLabel.textColor = FC_THEME_TASK_HEADER_TEXT_COLOR;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
//    cell.detailTextLabel.text = [[[self.tasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:TASK_ATTR_CATEGORY];
//    cell.detailTextLabel.textColor = FC_THEME_TASK_CONTENT_TEXT_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView* seperator = [[UIView alloc] initWithFrame:CGRectMake(0, TASK_LIST_CELL_HEIGHT-1, frame.size.width, 1)];
    [seperator setBackgroundColor:FC_THEME_DARK_TEXT_COLOR];
    [cell addSubview:seperator];
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    CGRect frame = [[UIScreen mainScreen] bounds];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, frame.size.width-15, TASK_LIST_CELL_HEIGHT-20)];
//    [label setBackgroundColor:FC_COLOR_DARK_RED];
    UIFont* font = [UIFont systemFontOfSize:24];
    
    [label setText:[[[self.tasks objectAtIndex:section] objectAtIndex:0] valueForKey:TASK_ATTR_CATEGORY]];
    [label setFont:font];
    [label setTextColor:FC_THEME_TASK_HEADER_TEXT_COLOR];
    
    [headerView addSubview:label];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TASK_LIST_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TASK_LIST_HEADER_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isUpdating) {
        CGRect original = cell.frame;
        [cell setFrame:CGRectMake(original.origin.x + 50, original.origin.y, original.size.width, original.size.height)];
        [cell setAlpha:0];
        
        
        [UIView animateWithDuration:0.6
                              delay:0.1 + indexPath.row*0.1
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             [cell setFrame:original];
                             [cell setAlpha:1];
                         }
                         completion:nil];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.tblView contentOffset].y < 0) {
        [self showCreateTask];
    } else if (isCreateShowing) {
        [self hideCreateTask];
    }
}

@end
