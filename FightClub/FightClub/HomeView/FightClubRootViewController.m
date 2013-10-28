//
//  FightClubRootViewController.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/24/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "FightClubRootViewController.h"
#import "FcConstant.h"

@interface FightClubRootViewController ()

@end


@implementation FightClubRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.homeView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
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
        [self.tblView setBackgroundColor:[UIColor clearColor]];
        
        
        [self.homeView addSubview:self.tblView];
        
        self.view = self.homeView;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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


@end
