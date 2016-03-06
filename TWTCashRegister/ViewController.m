//
//  ViewController.m
//  TWTCashRegister
//
//  Created by huixinming on 2/29/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import "ViewController.h"
#import "TWDatabaseManger.h"
#import "TWCashRegister.h"
#import "TWClearFeeViewController.h"
#import "TWConstants.h"



typedef NS_ENUM(NSUInteger,TWTestCase){
    TWTestCaseFirst = 1,
    TWTestCaseSecond,
    TWTestCaseThird,
    TWTestCaseFourth,
};

@interface ViewController ()

@end

@implementation ViewController
{
    TWDatabaseManger *dbManager;
    TWCashRegister *cashRegister;
    NSString *feeDetail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //configure favorable priority
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)clearingFee:(UIButton *)sender {
    NSArray *input = [NSArray arrayWithObjects:@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000003-2",@"ITEM000005",@"ITEM000005",@"ITEM000005", nil];
    
    if(TWTestCaseFirst == sender.tag)
    {
        NSString *delete = @"Delete FROM FavorableInfoTable";
        [dbManager execSql:delete];
        NSString *insert1 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000001','FreeOne',2.00)";
        [dbManager execSql:insert1];
        NSString *insert2 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000005','FreeOne',2.00)";
        [dbManager execSql:insert2];
    }
    else if (TWTestCaseSecond == sender.tag)
    {
        NSString *delete = @"Delete FROM FavorableInfoTable";
        [dbManager execSql:delete];
    }
    else if (TWTestCaseThird == sender.tag)
    {
        NSString *delete = @"Delete FROM FavorableInfoTable";
        [dbManager execSql:delete];
        NSString *insert = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000003','Discount',0.95)";
        [dbManager execSql:insert];
    }
    else if (TWTestCaseFourth == sender.tag)
    {
        input = [NSArray arrayWithObjects:@"ITEM000001",@"ITEM000001-2",@"ITEM000001",@"ITEM000001",@"ITEM000001",@"ITEM000003-2",@"ITEM000005",@"ITEM000005",@"ITEM000005", nil];
        NSString *delete = @"Delete FROM FavorableInfoTable";
        [dbManager execSql:delete];
        NSString *insert1 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000001','FreeOne',2.00)";
        [dbManager execSql:insert1];
        NSString *insert2 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000005','FreeOne',2.00)";
        [dbManager execSql:insert2];
        NSString *insert3 = @"Insert INTO FavorableInfoTable(Barcode,FavorableType,FavorableValue) VALUES('ITEM000003','Discount',0.95)";
        [dbManager execSql:insert3];
        
    }
    feeDetail = [cashRegister clearingFee:input];
    [self performSegueWithIdentifier:@"clearFee" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TWClearFeeViewController *clearFeeVC = segue.destinationViewController;
    if([clearFeeVC respondsToSelector:@selector(setFeeDetail:)])
    {
        [clearFeeVC setFeeDetail:feeDetail];
    }
}

@end
