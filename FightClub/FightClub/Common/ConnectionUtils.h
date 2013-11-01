//
//  ConnectionUtils.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/31/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionUtils : NSObject{
    BOOL fetchLock;
}

+ (ConnectionUtils*) getInstance;

- (void) prepareBackgroundTasks;

@end
