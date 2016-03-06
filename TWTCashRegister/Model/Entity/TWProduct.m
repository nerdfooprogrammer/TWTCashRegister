//
//  TWProduct.m
//  TWTCashRegister
//
//  Created by huixinming on 3/1/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import "TWProduct.h"
#import "TWDatabaseManger.h"

@interface TWProduct()

@property(nonatomic,copy,readwrite) NSString* barCode;
@property(nonatomic,copy,readwrite) NSString* name;
@property(nonatomic,assign,readwrite) float price;
@property(nonatomic,copy,readwrite) NSString* category;
@property(nonatomic,copy,readwrite) NSString* unit;

@end

@implementation TWProduct
{
    TWDatabaseManger *dbManager;
}

//Designated initializer
- (instancetype)initWithBarcode:(NSString*)barCode quantity:(float)quantity
{
    self = [super init];
    if(self)
    {
        dbManager = [TWDatabaseManger shareInstance];
        _barCode = barCode;
        _quantity = quantity;
        sqlite3_stmt *stmt = nil;
        NSString *query = [NSString stringWithFormat:@"select * from ProductInfoTable where Barcode = '%@'",barCode];
        BOOL ret = [dbManager queryDatabase:query withStmt:&stmt];
        if(ret)
        {
            const char* name = (const char *)sqlite3_column_text(stmt, 1);
            _name = [NSString stringWithUTF8String:name];
            _price = sqlite3_column_double(stmt, 2);
            const char* unit = (const char *)sqlite3_column_text(stmt, 3);
            _unit = [NSString stringWithUTF8String:unit];
            const char* category = (const char *)sqlite3_column_text(stmt, 4);
            _category = [NSString stringWithUTF8String:category];
        }
        sqlite3_finalize(stmt);
    }
    return self;
}

- (instancetype)init
{
    return [self initWithBarcode:@"******" quantity:0.0];
}

@end
