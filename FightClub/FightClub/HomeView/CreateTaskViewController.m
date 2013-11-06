//
//  CreateTaskViewController.m
//  FightClub
//
//  Created by Zhang, Qianze on 11/6/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "CreateTaskViewController.h"
#import "FcConstant.h"

@interface CreateTaskViewController ()

@end

@implementation CreateTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        CGRect frame = [[UIScreen mainScreen] bounds];
        UIView* mainView = [[UIView alloc] initWithFrame:frame];
        
        [mainView setBackgroundColor:FC_COLOR_WHITE];
        self.contentField = [[UITextField alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 400)];
        [self.contentField setBackgroundColor:FC_COLOR_BLACK];
        self.OKBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.OKBtn setTitle:@"OK" forState:UIControlStateNormal];
        [self.OKBtn setFrame:CGRectMake(frame.size.width - 100, 20, 80, 30)];
        
        
        [mainView addSubview:self.contentField];
        [mainView addSubview:self.OKBtn];
        
        self.view = mainView;
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

@end
