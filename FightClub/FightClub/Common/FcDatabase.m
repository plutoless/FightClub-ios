//
//  FcDatabase.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/30/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "FcDatabase.h"
#import "FcAlert.h"

@implementation FcDatabase

static FcDatabase* database = nil;

- (id) init
{
    self = [super init];
    if (self!=nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [paths objectAtIndex:0];
        self.db_path = [documents stringByAppendingPathComponent:DB_FILE_NAME];
    }
    return self;
}

-(void)execQuery:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"The query %@ failed", sql);
    }
}

- (void)construct
{
    if (![self openDatabase]) {
        return;
    }
    
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS Task (tid INTEGER PRIMARY KEY, content TEXT, ts TIMESTAMP NOT NULL)";
    [self execQuery:sqlCreateTable];
    
    [self closeDatabase];
}

- (BOOL)openDatabase
{
    if (sqlite3_open([self.db_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        [[FcAlert getInstance] showInfoAlertwithTitle:@"Error" message:@"Bad things happened to your database. This is a critical error, please re-install your application"];
        return NO;
    }
    
    return YES;
}

- (BOOL)closeDatabase
{
    sqlite3_close(db);
    return YES;
}

+ (void)initDatabase
{
    if (database == nil) {
        database = [[FcDatabase alloc] init];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:database.db_path]) {
        [database construct];
    }
}

+ (FcDatabase*)getInstance
{
    if (database == nil) {
        database = [[FcDatabase alloc] init];
    }
    
    return database;
}

- (void)deleteTasks
{
    if (![self openDatabase]) {
        return;
    }
    
    
    NSString *sqlDelete = @"DELETE FROM Task";
    [self execQuery:sqlDelete];
    
    
    [self closeDatabase];
}

- (void)insertTasks:(NSArray *)arrayOfTasks
{
//    if (willDelete) {
//        //remove all first when insert
//        [self deleteTasks];
//    }
    
    if (![self openDatabase]) {
        return;
    }
    
    for (NSDictionary* task in arrayOfTasks) {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO Task (tid, Content, ts) VALUES ('%@', '%@', '%@')", [task valueForKey:TASK_ATTR_TID], [task valueForKey:TASK_ATTR_CONTENT], [task valueForKey:TASK_ATTR_TS]];
        [self execQuery:sqlInsert];
    }

    
    [self closeDatabase];
}

- (void)deleteTasks:(NSArray *)arrayOfTasks
{
    if (![self openDatabase]) {
        return;
    }
    
    for (NSDictionary* task in arrayOfTasks) {
        NSString *sqlInsert = [NSString stringWithFormat:@"DELETE FROM Task WHERE tid = '%@'", [task valueForKey:TASK_ATTR_TID]];
        [self execQuery:sqlInsert];
    }
    
    
    [self closeDatabase];
}

- (NSArray*)getTasks
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    if (![self openDatabase]) {
        return result;
    }
    
    NSString *sqlQuery = @"SELECT tid, Content FROM Task ORDER BY ts DESC";
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSString* tid = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)];
            char *content = (char*)sqlite3_column_text(statement, 1);
            NSString *nsContent = [[NSString alloc]initWithUTF8String:content];
            
            NSMutableDictionary * taskAttr = [[NSMutableDictionary alloc] init];
            [taskAttr setObject:tid forKey:TASK_ATTR_TID];
            [taskAttr setObject:nsContent forKey:TASK_ATTR_CONTENT];
            [result addObject:taskAttr];
        }
    }
    
    
    [self closeDatabase];
    
    return result;
}

@end
