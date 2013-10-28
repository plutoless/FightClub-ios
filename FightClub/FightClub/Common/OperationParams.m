//
//  OperationParams.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/28/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "OperationParams.h"

@implementation OperationParams

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.requestURL = nil;
        self.requestHTTPMethod = @"GET";
    }
    
    return self;
}

@end
