//
//  FcDatabase.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/30/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "FcDatabase.h"
#import "FcAlert.h"
#import "Utils.h"

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
    
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS Task (tid INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT, ts TIMESTAMP NOT NULL, tgid INTEGER, isdone INTEGER, FOREIGN KEY(tgid) REFERENCES Category(tgid))";
    [self execQuery:sqlCreateTable];
    
    sqlCreateTable = @"CREATE TABLE IF NOT EXISTS Category (tgid INTEGER PRIMARY KEY, title TEXT, priority INTEGER NOT NULL)";
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

- (void)cleanup
{
    if (![self openDatabase]) {
        return;
    }
    
    
    NSString *sqlDelete = @"DELETE FROM Task";
    [self execQuery:sqlDelete];
    sqlDelete = @"DELETE FROM Category";
    [self execQuery:sqlDelete];
    
    [self closeDatabase];
}

- (void)insertTasks:(NSArray *)arrayOfTasks willDelete:(BOOL)willDelete
{
    if (willDelete) {
        //remove all first when insert
        [self cleanup];
    }
    
    if ([arrayOfTasks count] == 0) {
        return;
    }
    
    if (![self openDatabase]) {
        return;
    }
    
    for (NSArray* category in arrayOfTasks) {
        NSDictionary* firstItem = [category objectAtIndex:0];
        NSString *sqlInsertCategory = [NSString stringWithFormat:@"INSERT OR IGNORE INTO Category (tgid, title, priority) VALUES ('%@', '%@', '%@')", [firstItem valueForKey:TASK_ATTR_TGID], [firstItem valueForKey:TASK_ATTR_CATEGORY], [firstItem valueForKey:TASK_ATTR_PRIORITY]];
        [self execQuery:sqlInsertCategory];
        
        
        for (NSDictionary* task in category) {
            NSString *sqlInsertTask = [NSString stringWithFormat:@"INSERT OR IGNORE INTO Task (Content, ts, tgid, isdone) VALUES ('%@', '%@', %@, %@)", [task valueForKey:TASK_ATTR_CONTENT], [task valueForKey:TASK_ATTR_TS], [task valueForKey:TASK_ATTR_TGID], [task valueForKey:TASK_ATTR_ISDONE]];
            [self execQuery:sqlInsertTask];
        }
    }

    
    [self closeDatabase];
}

- (void)deleteTasks:(NSArray *)arrayOfTasks willDeleteCategory:(BOOL)willDeleteCategory
{
    if ([arrayOfTasks count] == 0) {
        return;
    }
    
    if (![self openDatabase]) {
        return;
    }
    
    NSString* tgid = nil;
    
    for (NSDictionary* task in arrayOfTasks) {
        if (tgid == nil) {
            tgid = [task valueForKey:TASK_ATTR_TGID];
        }
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM Task WHERE tid = '%@'", [task valueForKey:TASK_ATTR_TID]];
        [self execQuery:sqlDelete];
    }
    if (willDeleteCategory) {
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM Category WHERE tgid = '%@'", tgid];
        [self execQuery:sqlDelete];
    }
    
    [self closeDatabase];
}

- (void)updateTaskIsDone:(NSMutableDictionary *)task isdone:(BOOL)isdone
{
    
    if (![self openDatabase]) {
        return;
    }
    NSString *sqlUpdate = [NSString stringWithFormat:@"UPDATE TASK SET isdone=%@ WHERE tid = '%@'", isdone?TASK_ATTR_ISDONE_YES:TASK_ATTR_ISDONE_NO,[task valueForKey:TASK_ATTR_TID]];
    [self execQuery:sqlUpdate];
    [self closeDatabase];
}

- (NSArray*)getTasks
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    if (![self openDatabase]) {
        return result;
    }
    
    NSString *sqlQuery = @"SELECT tid, Content, Priority, Category.tgid, title, ts, isdone FROM Task JOIN Category ON Task.tgid = Category.tgid";
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSString* tid = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)];
            char *content = (char*)sqlite3_column_text(statement, 1);
            NSString *nsContent = [[NSString alloc]initWithUTF8String:content];
            NSString* nsPriority = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 2)];
            NSString* tgid = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 3)];
            NSString* nsTitle = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
            NSString* ts = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
            NSString* isdone = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 6)];
            
            NSMutableDictionary * taskAttr = [[NSMutableDictionary alloc] init];
            [taskAttr setObject:tid forKey:TASK_ATTR_TID];
            [taskAttr setObject:nsContent forKey:TASK_ATTR_CONTENT];
            [taskAttr setObject:tgid forKey:TASK_ATTR_TGID];
            [taskAttr setObject:nsTitle forKey:TASK_ATTR_CATEGORY];
            [taskAttr setObject:ts forKey:TASK_ATTR_TS];
            [taskAttr setObject:nsPriority forKey:TASK_ATTR_PRIORITY];
            [taskAttr setObject:isdone forKey:TASK_ATTR_ISDONE];
            [result addObject:taskAttr];
        }
    }
    
    
    [self closeDatabase];
    
    return result;
}

- (NSArray*)getSortedTasks
{
    NSArray* tasks = [self getTasks];
    return [Utils sortTasks:tasks];
}

@end
