//
//  SecManager.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/26/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "SecManager.h"

@implementation SecManager

static SecManager* secManager;

- (id) init
{
    self = [super init];
    if (self != nil) {
        self.secAttributes = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (SecManager*) getInstance
{
    @synchronized(self){
        if (secManager == nil) {
            secManager = [[SecManager alloc] init];
        }
    }
    return secManager;
}

@end
