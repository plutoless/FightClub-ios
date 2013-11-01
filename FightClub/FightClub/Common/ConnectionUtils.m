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
    if (connectionUtils == nil) {
        connectionUtils = [[ConnectionUtils alloc] init];
    }
    
    return connectionUtils;
}

- (void)startBackgroundTasks
{
    //we need to do following bg tasks
    //1. Start a Login Timer to keep session
    //2. Start an refresh timer to keep updating data
    [[[Utils getFcAppDelegate] homeViewController].navigationItem setTitle:@"Connecting..."];
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
        [[[Utils getFcAppDelegate] homeViewController].navigationItem setTitle:@"Loading..."];
        BaseHttpOperation* operation = [[BaseHttpOperation alloc] initWithObject:self target:@selector(didFinishLoadingTaskList:) type:FC_SERVICE_TYPE_GET_USER_TASK];
        [operation start];
    }
}

- (void)didFinishLoadingTaskList:(NSArray*)Response
{
    FightClubRootViewController* homeviewController = [[Utils getFcAppDelegate] homeViewController];
    NSMutableArray* originExits = [[NSMutableArray alloc] init];
    NSMutableArray* responseExists = [[NSMutableArray alloc] init];
    NSMutableArray* toBeInsert = [[NSMutableArray alloc] init];
    NSMutableArray* toBeDelete = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[homeviewController tasks] count]; i++) {
        [originExits addObject:TASK_ATTR_EXISTS_VAL_NO];
    }
    
    for (int i = 0; i < [Response count]; i++) {
        [responseExists addObject:TASK_ATTR_EXISTS_VAL_NO];
    }
    
    for (int i = 0; i < [[homeviewController tasks] count]; i++) {
        for (int j = 0; j < [Response count]; j++) {
            if ([[[[homeviewController tasks] objectAtIndex:i] valueForKey:TASK_ATTR_TID] isEqualToString:[[Response objectAtIndex:j] valueForKey:TASK_ATTR_TID]]) {
                [originExits replaceObjectAtIndex:i withObject:TASK_ATTR_EXISTS_VAL_YES];
                [responseExists replaceObjectAtIndex:j withObject:TASK_ATTR_EXISTS_VAL_YES];
            }
        }
    }
    
    for (int i = 0; i < [[homeviewController tasks] count]; i++) {
        if (![[originExits objectAtIndex:i] isEqualToString:TASK_ATTR_EXISTS_VAL_YES]) {
            [toBeDelete addObject:[[homeviewController tasks] objectAtIndex:i]];
        }
    }
    for (int i = 0; i < [Response count]; i++) {
        if (![[responseExists objectAtIndex:i] isEqualToString:TASK_ATTR_EXISTS_VAL_YES]) {
            [toBeInsert addObject:[Response objectAtIndex:i]];
        }
    }
    
    
    
    [homeviewController updateTasks:Response];
    
    [[FcDatabase getInstance] insertTasks:toBeInsert];
    [[FcDatabase getInstance] deleteTasks:toBeDelete];
    [homeviewController.navigationItem setTitle:@"Fight Club"];
}

@end
