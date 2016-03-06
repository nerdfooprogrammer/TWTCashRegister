//
//  TWFavorable.m
//  TWTCashRegister
//
//  Created by huixinming on 3/1/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import "TWFavorable.h"
#import "TWDatabaseManger.h"
#import "TWConstants.h"
@implementation TWFavorable

+ (TWFavorableType)checkFavorableType:(NSString*)barCode
{
    NSString *currentFavorableType = nil;
    TWFavorableType favorableType;
    NSArray<NSString*>* priority = [[NSUserDefaults standardUserDefaults] stringArrayForKey:kFavorablePriority];
    for (NSString*type in priority) {
        NSString *query = [NSString stringWithFormat:@"select * from FavorableInfoTable where FavorableType = '%@' AND Barcode = '%@'",type,barCode];
        sqlite3_stmt *stmt = nil;
        BOOL ret = [[TWDatabaseManger shareInstance] queryDatabase:query withStmt:&stmt];
        sqlite3_finalize(stmt);
        if(ret)
        {
            currentFavorableType = type;
            break;
        }
    }
    if([currentFavorableType isEqualToString:kFreeOne])
    {
        favorableType = TWFreeOne;
    }
    else if ([currentFavorableType isEqualToString:kDiscount])
    {
        favorableType = TWDiscount;
    }
    else
    {
        favorableType = TWNONE;
    }
    return favorableType;
}

@end
