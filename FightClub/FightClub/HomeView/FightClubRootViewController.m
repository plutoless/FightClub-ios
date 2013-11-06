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
        
        self.tblView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, screenFrame.size.width, screenFrame.size.height-20) style:UITableViewStylePlain];
        self.tblView.dataSource = self;
        self.tblView.delegate = self;
        [self.tblView setBackgroundColor:[UIColor clearColor]];
        self.tblView.sectionFooterHeight = 0.0;
        self.tblView.sectionHeaderHeight = 0.0;
        self.tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [self.homeView addSubview:self.tblView];
        
        self.view = self.homeView;
        
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self.navigationItem setTitle:@"TASKS"];
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
    cell.detailTextLabel.text = [[[self.tasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:TASK_ATTR_CATEGORY];
    cell.detailTextLabel.textColor = FC_THEME_TASK_CONTENT_TEXT_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView* seperator = [[UIView alloc] initWithFrame:CGRectMake(0, TASK_LIST_CELL_HEIGHT-1, frame.size.width, 1)];
    [seperator setBackgroundColor:FC_THEME_DARK_TEXT_COLOR];
    [cell addSubview:seperator];
    
    
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel* label = [[UILabel alloc] init];
//    UIFont* font = [UIFont boldSystemFontOfSize:18];
//    
//    [label setText:[[[self.tasks objectAtIndex:section] objectAtIndex:0] valueForKey:TASK_ATTR_CATEGORY]];
//    [label setFont:font];
//    [label setTextColor:FC_THEME_TASK_HEADER_TEXT_COLOR];
//    
//    [label sizeToFit];
//    
//    
//    return label;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TASK_LIST_CELL_HEIGHT;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 20;
//}

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


#pragma uiscrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView contentOffset].y <= PULL_TO_CREATE_TH) {
        CreateTaskViewController* newTask = [[CreateTaskViewController alloc] initWithNibName:nil bundle:nil];
        [self presentViewController:newTask animated:NO completion:^{
            CGRect mainFrame = [[UIScreen mainScreen] bounds];
            CGRect viewFrame = [newTask.view frame];
            [newTask.view setFrame:CGRectMake(0, -(mainFrame.size.height + [scrollView contentOffset].y), viewFrame.size.width, viewFrame.size.height)];
            
            [UIView animateWithDuration:1
                             animations:^{
                                 [newTask.view setFrame:viewFrame];
                             } completion:^(BOOL finished){
                
            }];
        }];
    }
}

@end
