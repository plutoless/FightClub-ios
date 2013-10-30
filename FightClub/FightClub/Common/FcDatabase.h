//
//  FcDatabase.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/30/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FcConstant.h"

@interface FcDatabase : NSObject
{
    sqlite3 *db;
}

@property (nonatomic, retain)NSString* db_path;

+ (void) initDatabase;
+ (FcDatabase*) getInstance;

- (void) insertTasks:(NSArray*)arrayOfTasks;
- (NSArray*) getTasks;
@end
