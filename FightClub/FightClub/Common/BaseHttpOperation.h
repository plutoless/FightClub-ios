//
//  BaseHttpOperation.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/28/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServicesManager.h"

@class OperationParams;

@interface BaseHttpOperation : NSOperation<NSURLConnectionDataDelegate>


@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, assign) SEL target;
@property (nonatomic, assign) id object;
@property (nonatomic, assign) FcServiceType type;
@property (nonatomic, retain) OperationParams* param;

- (id) initWithObject:(id)object target:(SEL)target;
- (id) initWithObject:(id)object target:(SEL)target type:(FcServiceType)type;
- (id) initWithObject:(id)object target:(SEL)target param:(OperationParams*)param;

@end
