//
//  LoginOperation.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/26/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginOperation : NSOperation<NSURLConnectionDataDelegate>

@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, assign) SEL target;
@property (nonatomic, assign) id object;

- (id) initWithObject:(id)object target:(SEL)target;

@end
