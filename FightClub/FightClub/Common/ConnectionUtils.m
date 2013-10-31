//
//  ConnectionUtils.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/31/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "ConnectionUtils.h"
#import "LoginOperation.h"
#import "AppDelegate.h"
#import "FcConstant.h"
#import "FcAlert.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "SecManager.h"
#import "BaseHttpOperation.h"
#import "FightClubRootViewController.h"
#import "FcDatabase.h"

@implementation ConnectionUtils

static ConnectionUtils* connectionUtils;

+ (ConnectionUtils*)getInstance
{
    if (connectionUtils != nil) {
        connectionUtils = [[ConnectionUtils alloc] init];
    }
    
    return connectionUtils;
}

- (void)startBackgroundTasks
{
    //we need to do following bg tasks
    //1. Start a Login Timer to keep session
    //2. Start an refresh timer to keep updating data
    [[[Utils getFcAppDelegate] navigationController] setTitle:@"Connecting..."];
    LoginOperation* loginOper = [[LoginOperation alloc] initWithObject:self target:@selector(loginSuccessful:)];
    [loginOper start];
}

- (void)loginSuccessful:(NSDictionary*)Response
{
    BOOL valid = [[Response valueForKey:LOGIN_RESPONSE_STATUS] boolValue];
    if (!valid) {
        //if failed to logon, navigate back to logon screen
        [[FcAlert getInstance] showInfoAlertwithTitle:@"Error" message:@"Login Failed. Please check your username and password."];
        [[[Utils getFcAppDelegate] navigationController] popToRootViewControllerAnimated:YES];
    } else {
        [[[Utils getFcAppDelegate] navigationController] setTitle:@"Loading..."];
        BaseHttpOperation* operation = [[BaseHttpOperation alloc] initWithObject:self target:@selector(didFinishLoadingTaskList:) type:FC_SERVICE_TYPE_GET_USER_TASK];
        [operation start];
    }
}

- (void)didFinishLoadingTaskList:(NSArray*)Response
{
    FightClubRootViewController* homeviewController = [[Utils getFcAppDelegate] homeViewController];
    UINavigationController* navController = [[Utils getFcAppDelegate] navigationController];
    [homeviewController setTasks:Response];
    [[FcDatabase getInstance] insertTasks:Response];
    [navController setTitle:@"Fight Club"];
}

@end
