//
//  ServicesManager.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/27/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "ServicesManager.h"
#import "FcConstant.h"
#import "SecManager.h"

#define FC_SERVER_BASE_URL @"http://kilimanjarotech.com/fightclub/service/"

@implementation ServicesManager

static ServicesManager* serviceManager;

- (id) init
{
    self = [super init];
    if (self != nil) {
        self.services = [[NSMutableDictionary alloc] init];
        [self.services setObject:[FC_SERVER_BASE_URL stringByAppendingString:@"common/login.php"] forKey:SERVICE_MACRO_LOGIN];
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

+ (NSString*)getServiceURLById:(FcServiceType)type
{
    NSString* url = nil;
    switch (type) {
        case FC_SERVICE_TYPE_LOGIN:
            
            break;
        case FC_SERVICE_TYPE_GET_USER_TASK:
            url = [NSString stringWithFormat:@"%@common/webactions.php?webaction=%d", FC_SERVER_BASE_URL, 1];
            break;
        default:
            break;
    }
    
    return url;
}

@end
