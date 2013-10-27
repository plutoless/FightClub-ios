//
//  ServicesManager.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/27/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "ServicesManager.h"
#import "FcConstant.h"

#define FC_SERVER_BASE_URL @"http://kilimanjarotech.com/fightclub/service/common/"

@implementation ServicesManager

static ServicesManager* serviceManager;

- (id) init
{
    self = [super init];
    if (self != nil) {
        self.services = [[NSMutableDictionary alloc] init];
        [self.services setObject:[FC_SERVER_BASE_URL stringByAppendingString:@"login.php"] forKey:SERVICE_MACRO_LOGIN];
    }
    
    return self;
}

+ (ServicesManager*)getInstance
{
    if (serviceManager == nil) {
        serviceManager = [[ServicesManager alloc] init];
    }
    
    return serviceManager;
}

@end
