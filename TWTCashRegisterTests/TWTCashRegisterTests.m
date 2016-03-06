//
//  TWTCashRegisterTests.m
//  TWTCashRegisterTests
//
//  Created by huixinming on 2/29/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <sqlite3.h>
#import "TWDatabaseManger.h"
#import "TWCashRegister.h"
#import "TWTCashRegisterTests.m"
#import "TWConstants.h"

@interface TWTCashRegisterTests : XCTestCase

@end

@implementation TWTCashRegisterTests
{
    TWDatabaseManger *dbManager;
    TWCashRegister *cashRegister;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSArray *priority = [NSArray arrayWithObjects:kFreeOne,kDiscount, nil];
    [[NSUserDefaults standardUserDefaults] setObject:priority forKey:kFavorablePriority];
    dbManager = [TWDatabaseManger shareInstance];
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    if(![[NSFileManager defaultManager] fileExistsAtPath:database_path])
    {
        [self initDatabase:database_path];
        [self createTable];
        [self insertData];
    }
    else
    {
        [dbManager openDatabase:database_path];
    }
    cashRegister = [[TWCashRegister alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testOnlyFreeOne
{
    NSString *delete = @"Delete FROM FavorableInfoTable";
    [dbManager execSql:delete];
    NSString *insert1 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000001','FreeOne',2.00)";
    [dbManager execSql:insert1];
    NSString *insert2 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000005','FreeOne',2.00)";
    [dbManager execSql:insert2];
    
    NSArray *input = [NSArray arrayWithObjects:@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000003-2",@"ITEM000005",@"ITEM000005",@"ITEM000005", nil];
    [cashRegister clearingFee:input];
    XCTAssertEqualWithAccuracy(cashRegister.totalFee,21.00,0.0001,@"In this test case,total fee should be 21.00");
    XCTAssertEqualWithAccuracy(cashRegister.savedFee,4.00,0.0001,@"In this test case,total fee should be 4.00");
}

- (void)testNoFavourableProduct
{
    NSString *delete = @"Delete FROM FavorableInfoTable";
    [dbManager execSql:delete];
    NSArray *input = [NSArray arrayWithObjects:@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000003-2",@"ITEM000005",@"ITEM000005",@"ITEM000005", nil];
    [cashRegister clearingFee:input];
    XCTAssertEqualWithAccuracy(cashRegister.totalFee,25.00,0.0001,@"In this test case,total fee should be 25.00");
    XCTAssertEqualWithAccuracy(cashRegister.savedFee,0.00,0.0001,@"In this test case,total fee should be 0.00");
}

- (void)testOnlyDiscount
{
    NSString *delete = @"Delete FROM FavorableInfoTable";
    [dbManager execSql:delete];
    NSString *insert = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000003','Discount',0.95)";
    [dbManager execSql:insert];
    NSArray *input = [NSArray arrayWithObjects:@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000003-2",@"ITEM000005",@"ITEM000005",@"ITEM000005", nil];
    [cashRegister clearingFee:input];
    XCTAssertEqualWithAccuracy(cashRegister.totalFee,24.45,0.0001,@"In this test case,total fee should be 24.45");
    XCTAssertEqualWithAccuracy(cashRegister.savedFee,0.55,0.0001,@"In this test case,total fee should be 0.55");
}

- (void)testBothFavorableWithFreeOnePriorityHigh
{
    NSString *delete = @"Delete FROM FavorableInfoTable";
    [dbManager execSql:delete];
    NSString *insert1 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000001','FreeOne',2.00)";
    [dbManager execSql:insert1];
    NSString *insert2 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000005','FreeOne',2.00)";
    [dbManager execSql:insert2];
    NSString *insert3 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000003','Discount',0.95)";
    [dbManager execSql:insert3];
    NSArray *input = [NSArray arrayWithObjects:@"ITEM000001",@"ITEM000001-2",@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000003-2",@"ITEM000005",@"ITEM000005",@"ITEM000005", nil];
    [cashRegister clearingFee:input];
    XCTAssertEqualWithAccuracy(cashRegister.totalFee,20.45,0.0001,@"In this test case,total fee should be 20.45");
    XCTAssertEqualWithAccuracy(cashRegister.savedFee,5.55,0.0001,@"In this test case,total fee should be 5.55");
}

- (void)testBothFavorableWithDiscountPriorityHigh
{
    NSArray *priority = [NSArray arrayWithObjects:kDiscount,kFreeOne, nil];
    [[NSUserDefaults standardUserDefaults] setObject:priority forKey:kFavorablePriority];
    NSString *delete = @"Delete FROM FavorableInfoTable";
    [dbManager execSql:delete];
    NSString *insert1 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000001','FreeOne',2.00)";
    [dbManager execSql:insert1];
    NSString *insert2 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000005','FreeOne',2.00)";
    [dbManager execSql:insert2];
    NSString *insert3 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000003','Discount',0.95)";
    [dbManager execSql:insert3];
    NSString *insert4 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000001','Discount',0.95)";
    [dbManager execSql:insert4];
    NSString *insert5 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000005','Discount',0.95)";
    [dbManager execSql:insert5];
    NSArray *input = [NSArray arrayWithObjects:@"ITEM000001",@"ITEM000001-2",@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000003-2",@"ITEM000005",@"ITEM000005",@"ITEM000005", nil];
    [cashRegister clearingFee:input];
    XCTAssertEqualWithAccuracy(cashRegister.totalFee,24.70,0.0001,@"In this test case,total fee should be 24.70");
    XCTAssertEqualWithAccuracy(cashRegister.savedFee,1.30,0.0001,@"In this test case,total fee should be 1.30");
}
- (void)initDatabase:(NSString*)path
{
    [dbManager openDatabase:path];
}

- (void)createTable
{
    NSString *createProductInfoTable = @"Create TABLE if not exists ProductInfoTable(Barcode text primary key not null,Name text,Price real,Unit text,Category text)";
    [dbManager execSql:createProductInfoTable];
    NSString *createFavorableInfoTable = @"Create TABLE if not exists FavorableInfoTable(id Integer primary key autoincrement not null,Barcode text,FavorableType text,FavorableValue float)";
    [dbManager execSql:createFavorableInfoTable];
}

- (void)insertData
{
    //插入商品信息
    NSString *insertBadminton = @"Insert INTO ProductInfoTable(Barcode,Name,Price,Unit,Category) VALUES('ITEM000001','羽毛球',1.00,'个','Sport')";
    [dbManager execSql:insertBadminton];
    NSString *insertApple = @"Insert INTO ProductInfoTable(Barcode,Name,Price,Unit,Category) VALUES('ITEM000003','苹果',5.50,'斤','Fruit')";
    [dbManager execSql:insertApple];
    NSString *insertCocoa = @"Insert INTO ProductInfoTable(Barcode,Name,Price,Unit,Category) VALUES('ITEM000005','可口可乐',3.00,'瓶','Drink')";
    [dbManager execSql:insertCocoa];
    
}

@end
