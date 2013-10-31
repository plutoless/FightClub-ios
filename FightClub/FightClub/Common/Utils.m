//
//  Utils.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/31/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "Utils.h"
#import "AppDelegate.h"

@implementation Utils

+ (AppDelegate*)getFcAppDelegate
{
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
}

@end
