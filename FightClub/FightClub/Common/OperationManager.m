//
//  OperationManager.m
//  FightClub
//
//  Created by Zhang, Qianze on 11/1/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "OperationManager.h"

@implementation OperationManager

static OperationManager* operMgr;

- (id) init
{
    self = [super init];
    if (self != nil) {
        self.operationList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (OperationManager*) getInstance
{
    if (operMgr == nil) {
        operMgr = [[OperationManager alloc] init];
    }
    
    return operMgr;
}

- (void) addOperation:(NSOperation*)operation
{
    [self.operationList addObject:operation];
}

- (void) removeOperation:(NSOperation*)operation
{
    [self.operationList removeObject:operation];
}

@end
