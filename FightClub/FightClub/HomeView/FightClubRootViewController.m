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
#import "AllTouchesGestureRecognizer.h"
#import "FcDatabase.h"

#define TASK_LIST_TABLE_PADDING_X 10
#define TASK_DONE_VIEW_TAG 3

@interface FightClubRootViewController ()

@end


@implementation FightClubRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        needAnimate = YES;
        isCreateShowing = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        CGRect screenFrame = [[UIScreen mainScreen] bounds];
        // Custom initialization
        self.homeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width, screenFrame.size.height)];
        self.tasks = [[NSMutableArray alloc] init];
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
        
        self.touchOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, TASK_LIST_CREATE_TASK_HEIGHT, screenFrame.size.width, screenFrame.size.height - TASK_LIST_CREATE_TASK_HEIGHT)];
//        [self.touchOverlay setBackgroundColor:FC_COLOR_BLACK];
        [self.touchOverlay setHidden:YES];
        AllTouchesGestureRecognizer* touch = [[AllTouchesGestureRecognizer alloc] initWithTarget:self action:@selector(hideCreateTask)];
        [self.touchOverlay addGestureRecognizer:touch];
        
        
        self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, -TASK_LIST_CREATE_TASK_HEIGHT, screenFrame.size.width, TASK_LIST_CREATE_TASK_HEIGHT)];
        
        self.createTaskField = [[UITextField alloc] initWithFrame:CGRectMake(TASK_LIST_CREATE_TASK_PADDING, 0, screenFrame.size.width - TASK_LIST_CREATE_TASK_PADDING*2, TASK_LIST_CREATE_TASK_HEIGHT)];
//        [self.createTaskField setBackgroundColor:FC_COLOR_BLACK];
        [self.createTaskField setTextColor:FC_THEME_TASK_HEADER_TEXT_COLOR];
        self.createTaskField.delegate = self;
        [self.createTaskField setPlaceholder:@"New a task..."];
        UIView* topViewSeperator = [[UIView alloc] initWithFrame:CGRectMake(0, TASK_LIST_CREATE_TASK_HEIGHT - 1, screenFrame.size.width, 1)];
        [topViewSeperator setBackgroundColor:FC_THEME_SEP_COLOR];
        [self.topView addSubview:self.createTaskField];
        [self.topView addSubview:topViewSeperator];
        
        
        [self.homeView addSubview:self.topView];
        [self.homeView addSubview:self.tblView];
        [self.homeView addSubview:self.touchOverlay];
        
        self.view = self.homeView;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationItem setTitle:@"TASKS"];
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

- (void) updateTasks:(NSMutableArray*)tasks
{
    needAnimate = NO;
    [self setTasks:tasks];
    [[self tblView] reloadData];
}

- (void) showCreateTask
{
    [self.createTaskField becomeFirstResponder];
    [self.tblView setContentInset:UIEdgeInsetsMake(TASK_LIST_CREATE_TASK_HEIGHT, 0, 0, 0)];
    [self.touchOverlay setHidden:NO];
    isCreateShowing = YES;
}

- (void) hideCreateTask
{
    [UIView animateWithDuration:0.3
        animations:^{
            [self.tblView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        } completion:^(BOOL finished){
            
            [self.createTaskField resignFirstResponder];
            [self.createTaskField setText:@""];
        }];
    [self.createTaskField resignFirstResponder];
    [self.touchOverlay setHidden:YES];
    isCreateShowing = NO;
}

- (void) deleteTask:(UIButton*)sender
{
    UIView *target = sender.superview;
    UITableViewCell* cell = nil;
    
    while (target != nil) {
        if ([target isKindOfClass:[UITableViewCell class]]) {
            cell = (UITableViewCell*)target;
            break;
        } else {
            target = target.superview;
        }
    }
    
    if (cell == nil) {
        return;
    }
    
    NSIndexPath* indexPath = [self.tblView indexPathForCell:cell];
    
    NSMutableArray* tasksByCategory = [[self.tasks objectAtIndex:indexPath.section] valueForKey:CAT_ATTR_ITEMS];
    NSDictionary* deleteTask = [tasksByCategory objectAtIndex:indexPath.row];
    
    if ([tasksByCategory count] > 1) {
        [[FcDatabase getInstance] deleteTasks:[NSArray arrayWithObject:deleteTask] willDeleteCategory:NO];
        [tasksByCategory removeObjectAtIndex:indexPath.row];
    } else {
        [[FcDatabase getInstance] deleteTasks:[NSArray arrayWithObject:deleteTask] willDeleteCategory:YES];
        [tasksByCategory removeObjectAtIndex:indexPath.row];
        [self.tasks removeObjectAtIndex:indexPath.section];
    }
    
    
    [self.tblView beginUpdates];
    
    if ([tasksByCategory count] > 0) {
        [self.tblView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tblView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tblView endUpdates];
}
    
-(void)addTaskCell:(NSIndexPath*)indexPath isNewSection:(BOOL)isNewSection
{
    needAnimate = NO;
    if (isNewSection) {
        [self.tblView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tblView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)deleteTaskCell:(NSIndexPath*)indexPath willDeleteSection:(BOOL)willDeleteSection
{
    needAnimate = NO;
    if (willDeleteSection) {
        [self.tblView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tblView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)completeTask:(UIGestureRecognizer*)sender
{
    UITableViewCell *cell = (UITableViewCell*)sender.view;
    
    NSIndexPath* indexPath = [self.tblView indexPathForCell:cell];
    NSMutableArray* tasks = [[self.tasks objectAtIndex:indexPath.section] valueForKey:CAT_ATTR_ITEMS];
    NSMutableDictionary* task = [tasks objectAtIndex:indexPath.row];
    [task setValue:TASK_ATTR_ISDONE_YES forKey:TASK_ATTR_ISDONE];
    [[FcDatabase getInstance] updateTaskIsDone:task isdone:YES];
    NSMutableDictionary* taskCopy = [[NSMutableDictionary alloc] initWithDictionary:task];
    NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:([tasks count]-1) inSection:indexPath.section];
    [tasks removeObjectAtIndex:indexPath.row];
    [self.tblView beginUpdates];
    [self deleteTaskCell:indexPath willDeleteSection:NO];
    [self.tblView endUpdates];
    [tasks addObject:taskCopy];
    [self.tblView beginUpdates];
    [self addTaskCell:newIndexPath isNewSection:NO];
    [self.tblView endUpdates];
    
}

-(void)uncompleteTask:(UIGestureRecognizer*)sender
{
    UITableViewCell *cell = (UITableViewCell*)sender.view;
    
    NSIndexPath* indexPath = [self.tblView indexPathForCell:cell];
    NSMutableArray* tasks = [[self.tasks objectAtIndex:indexPath.section] valueForKey:CAT_ATTR_ITEMS];
    NSMutableDictionary* task = [tasks objectAtIndex:indexPath.row];
    [task setValue:TASK_ATTR_ISDONE_NO forKey:TASK_ATTR_ISDONE];
    [[FcDatabase getInstance] updateTaskIsDone:task isdone:NO];
    NSMutableDictionary* taskCopy = [[NSMutableDictionary alloc] initWithDictionary:task];
    NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    [tasks removeObjectAtIndex:indexPath.row];
    [self.tblView beginUpdates];
    [self deleteTaskCell:indexPath willDeleteSection:NO];
    [self.tblView endUpdates];
    [tasks insertObject:taskCopy atIndex:0];
    [self.tblView beginUpdates];
    [self addTaskCell:newIndexPath isNewSection:NO];
    [self.tblView endUpdates];
}

#pragma UITableViewDelegate UITableDatasource functions
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.tasks objectAtIndex:section] valueForKey:CAT_ATTR_ITEMS] count];
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
    NSDictionary* task = [[[self.tasks objectAtIndex:indexPath.section] valueForKey:CAT_ATTR_ITEMS] objectAtIndex:indexPath.row];
    cell.textLabel.text = [task valueForKey:TASK_ATTR_CONTENT];
    cell.textLabel.textColor = FC_THEME_TASK_HEADER_TEXT_COLOR;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
//    cell.detailTextLabel.text = [[[self.tasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:TASK_ATTR_CATEGORY];
//    cell.detailTextLabel.textColor = FC_THEME_TASK_CONTENT_TEXT_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton* deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteTask:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setFrame:CGRectMake(frame.size.width - 60, 0, 40, 40)];
    [cell addSubview:deleteBtn];
    
    UIView* seperator = [[UIView alloc] initWithFrame:CGRectMake(0, TASK_LIST_CELL_HEIGHT-1, frame.size.width, 1)];
    [seperator setBackgroundColor:FC_THEME_SEP_COLOR];
    [cell addSubview:seperator];
    
    UIView* done = [[UIView alloc] initWithFrame:CGRectMake(10, TASK_LIST_CELL_HEIGHT/2, frame.size.width - 100, 1)];
    [done setTag:TASK_DONE_VIEW_TAG];
    [done setBackgroundColor:FC_COLOR_BLACK_TRANS];
    [cell addSubview:done];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    CGRect frame = [[UIScreen mainScreen] bounds];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, frame.size.width-15, TASK_LIST_CELL_HEIGHT-20)];
//    [label setBackgroundColor:FC_COLOR_DARK_RED];
    UIFont* font = [UIFont systemFontOfSize:24];
    
    [label setText:[[self.tasks objectAtIndex:section] valueForKey:CAT_ATTR_TITLE]];
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
    if (needAnimate) {
//        CGRect original = cell.frame;
//        [cell setFrame:CGRectMake(original.origin.x + 50, original.origin.y, original.size.width, original.size.height)];
        [cell setAlpha:0];
        
        
        [UIView animateWithDuration:1
                              delay:0.1 + indexPath.row*0.1
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
//                             [cell setFrame:original];
                             [cell setAlpha:1];
                         }
                         completion:nil];
    }
    
    UISwipeGestureRecognizer* swipe = nil;
    NSMutableDictionary* task = [[[self.tasks objectAtIndex:indexPath.section] valueForKey:CAT_ATTR_ITEMS] objectAtIndex:indexPath.row];
    UIView* done = [cell viewWithTag:TASK_DONE_VIEW_TAG];
    if (![[task valueForKey:TASK_ATTR_ISDONE] isEqualToString:TASK_ATTR_ISDONE_YES]) {
        for (UIGestureRecognizer* gr in [cell gestureRecognizers]) {
            [cell removeGestureRecognizer:gr];
        }
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(completeTask:)];
        [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
        [cell addGestureRecognizer:swipe];
        [done setHidden:YES];
    } else {
        for (UIGestureRecognizer* gr in [cell gestureRecognizers]) {
            [cell removeGestureRecognizer:gr];
        }
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(uncompleteTask:)];
        [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
        [cell addGestureRecognizer:swipe];
        cell.textLabel.textColor = FC_COLOR_BLACK_TRANS;
        [done setHidden:NO];
    }
    
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if ([self.tblView contentOffset].y < -(TASK_LIST_CREATE_TASK_HEIGHT - 1)) {
//        [self showCreateTask];
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = [scrollView contentOffset].y;
    if (offset >= -TASK_LIST_CREATE_TASK_HEIGHT && offset <= 0) {
        CGRect frame = [self.createTaskField frame];
        [self.topView setFrame:CGRectMake(0, -TASK_LIST_CREATE_TASK_HEIGHT - offset, frame.size.width, frame.size.height)];
    } else if (offset < -TASK_LIST_CREATE_TASK_HEIGHT && ![self.createTaskField isFirstResponder]){
        [self showCreateTask];
    }
}

#pragma UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.createTaskField && [self.createTaskField isFirstResponder]) {
        BOOL categoryExists = NO;
        int mobileCateIndex = 0;
        
        NSMutableDictionary* newTask = [[NSMutableDictionary alloc] init];
        [newTask setValue:@"Mobile" forKey:TASK_ATTR_CATEGORY];
        [newTask setValue:[textField text] forKey:TASK_ATTR_CONTENT];
        [newTask setValue:TASK_CATEGORY_MOBILE_TGID forKey:TASK_ATTR_TGID];
        [newTask setValue:[Utils getCurrentTimeStamp] forKey:TASK_ATTR_TS];
        [newTask setValue:TASK_CATEGORY_MOBILE_PRIORITY forKey:TASK_ATTR_PRIORITY];
        [newTask setValue:TASK_ATTR_ISDONE_NO forKey:TASK_ATTR_ISDONE];
        
        for (int i = 0; i < [self.tasks count]; i++) {
            NSMutableDictionary* tempCat = [self.tasks objectAtIndex:i];
            if ([[tempCat objectForKey:CAT_ATTR_TITLE] isEqualToString:@"Mobile"]) {
                categoryExists = YES;
                mobileCateIndex = i;
                break;
            }
        }
        
        if (!categoryExists) {
            //if not exist, we create one first
            NSMutableDictionary* newCategory = [Utils createCatWithTemplateTask:newTask];
            [[newCategory valueForKey:CAT_ATTR_ITEMS] addObject:newTask];
            [self.tasks insertObject:newCategory atIndex:0];
            [self.tblView beginUpdates];
            [self addTaskCell:[NSIndexPath indexPathForRow:0 inSection:0] isNewSection:YES];
            [self.tblView endUpdates];
        } else {
            NSMutableDictionary* category = [self.tasks objectAtIndex:mobileCateIndex];
            [[category valueForKey:CAT_ATTR_ITEMS] insertObject:newTask atIndex:0];
            [self.tblView beginUpdates];
            [self addTaskCell:[NSIndexPath indexPathForRow:0 inSection:mobileCateIndex] isNewSection:NO];
            [self.tblView endUpdates];
        }
        
        [[FcDatabase getInstance] insertTasks:[NSArray arrayWithObject:[NSArray arrayWithObject:newTask]] willDelete:NO];
//        [self updateTasks:self.tasks];
        
        
        [self hideCreateTask];
    }
    
    return YES;
}


@end
