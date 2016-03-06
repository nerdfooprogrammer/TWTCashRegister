//
//  TWDatabaseManger.m
//  TWTCashRegister
//
//  Created by huixinming on 2/29/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import "TWDatabaseManger.h"


@implementation TWDatabaseManger
{
    sqlite3 *db;
    NSInteger dbResult;
}
static TWDatabaseManger* defaultManager = nil;

#pragma mark -- initialized
+ (instancetype)shareInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        defaultManager = [[TWDatabaseManger alloc] init];
    });
    return defaultManager;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t token;
     dispatch_once(&token, ^{
         if(defaultManager == nil)
         {
            defaultManager = [super allocWithZone:zone];
         }
     });
     return defaultManager;
}

- (id)copy
{
    return self;
}

- (id)mutableCopy
{
    return self;
}

#pragma mark -- database operation

- (NSInteger)openDatabase:(NSString*)path
{
    dbResult = sqlite3_open(path.UTF8String, &db);
    if(SQLITE_OK != dbResult)
    {
        NSLog(@"数据库打开失败");
        sqlite3_close(db);
    }
    return dbResult;
}

- (NSInteger)execSql:(NSString*)sql
{
    char *errMsg;
    dbResult = sqlite3_exec(db, sql.UTF8String, nil, nil, &errMsg);
    if(SQLITE_OK != dbResult)
    {
        NSLog(@"数据库操作失败，详细信息:%s",errMsg);
        sqlite3_close(db);
    }
    return dbResult;
}

- (BOOL)queryDatabase:(NSString*)sql withStmt:(sqlite3_stmt**)stmt
{
    *stmt = nil;
    dbResult = sqlite3_prepare_v2(db, sql.UTF8String, -1,stmt, nil);
    if(SQLITE_OK != dbResult)
    {
        NSLog(@"数据库查询失败");
        sqlite3_close(db);
        return NO;
    }
    if(SQLITE_ROW != sqlite3_step(*stmt))
    {
        NSLog(@"数据库中无此项数据");
        return NO;
    }
    return YES;
}

@end
