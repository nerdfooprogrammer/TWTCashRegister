//
//  TWDatabaseManger.h
//  TWTCashRegister
//
//  Created by huixinming on 2/29/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

/* 数据库访问接口封装，数据库的访问应该是统一的，故而该类实现了“严格的单例”,本项目中所有的商品详情(条形码、价格等)
   以及优惠商品信息均存储在数据库中
 */

@interface TWDatabaseManger : NSObject

+ (instancetype)shareInstance;
- (NSInteger)openDatabase:(NSString*)path;
- (NSInteger)execSql:(NSString*)sql;
- (BOOL)queryDatabase:(NSString*)sql withStmt:(sqlite3_stmt**)stmt;

@end
