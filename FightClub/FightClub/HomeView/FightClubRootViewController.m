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

#define TASK_LIST_TABLE_PADDING_X 10

@interface FightClubRootViewController ()

@end


@implementation FightClubRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isUpdating = NO;
        
        CGRect screenFrame = [[UIScreen mainScreen] bounds];
        // Custom initialization
        self.homeView = [[UIView alloc] initWithFrame:CGRectMake(screenFrame.origin.x + TASK_LIST_TABLE_PADDING_X, 0, screenFrame.size.width - TASK_LIST_TABLE_PADDING_X * 2, screenFrame.size.height)];
        self.tasks = [[NSArray alloc] init];
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIImage *bgImg = [UIImage imageNamed:@"login.jpg"];
        [bgView setImage:bgImg];
        [bgView setContentMode:UIViewContentModeRight];
        [bgView setContentScaleFactor:1.8];
        
        [self.homeView addSubview:bgView];
        
        self.tblView = [[UITableView alloc] initWithFrame:self.homeView.frame style:UITableViewStyleGrouped];
        self.tblView.dataSource = self;
        self.tblView.delegate = self;
        [self.tblView setContentInset:UIEdgeInsetsMake(40, 0, 0, 0)];
        [self.tblView setBackgroundColor:[UIColor clearColor]];
        
        
        [self.homeView addSubview:self.tblView];
        
        self.view = self.homeView;
        
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    return UIStatusBarStyleLightContent;
}

- (void) updateTasks:(NSArray*)tasks
{
    isUpdating = YES;
    [self setTasks:tasks];
    [[self tblView] reloadData];
}

#pragma UITableViewDelegate UITableDatasource functions
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tasks count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    cell.textLabel.text = [[self.tasks objectAtIndex:indexPath.row] valueForKey:TASK_ATTR_CONTENT];
    
    return cell;
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
                              delay:indexPath.row*0.1
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             [cell setFrame:original];
                             [cell setAlpha:1];
                         }
                         completion:nil];
    }
    
}


@end
