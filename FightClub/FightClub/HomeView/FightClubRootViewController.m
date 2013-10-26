//
//  FightClubRootViewController.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/24/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "FightClubRootViewController.h"

@interface FightClubRootViewController ()

@end


@implementation FightClubRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.homeView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIImage *bgImg = [UIImage imageNamed:@"login.jpg"];
        [bgView setImage:bgImg];
        [bgView setContentMode:UIViewContentModeRight];
        [bgView setContentScaleFactor:1.8];
        
        [self.homeView addSubview:bgView];
        self.view = self.homeView;
    }
    return self;
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

@end
