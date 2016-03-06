//
//  TWCashRegister.m
//  TWTCashRegister
//
//  Created by huixinming on 3/1/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import "TWCashRegister.h"
#import "TWParse.h"
#import "TWProduct.h"
#import "TWFavorable.h"
#import "TWConstants.h"

@interface TWCashRegister()

@property(nonatomic,assign,readwrite) float totalFee;
@property(nonatomic,assign,readwrite) float savedFee;

@end

@implementation TWCashRegister

- (NSString*)clearingFee:(NSArray<NSString*>*)list
{
    float totalCost = 0.0;
    float saveCost = 0.0;
    NSMutableString *productDetail = [NSMutableString string];
    NSMutableString *freeOneDetail = [NSMutableString string];
    NSDictionary *productInfo = [TWParse parseProductList:list];
    NSArray<TWProduct*>*productList = [self constructProduct:productInfo];
    for (TWProduct *item in productList) {
        TWFavorableType type = [TWFavorable checkFavorableType:item.barCode];
        float itemTotal = 0.0;
        if(TWFreeOne == type)
        {
            int saveNum = floorf(item.quantity / kFreeOneValue);
            saveCost += saveNum * item.price;
            itemTotal = (item.quantity - saveNum) * item.price;
            [productDetail appendFormat:@"名称:%@,数量:%.0f%@,单价:%.2f(元),小计:%.2f(元)\r\n",item.name,item.quantity,item.unit,item.price,itemTotal];
            [freeOneDetail appendFormat:@"名称:%@,数量:%d%@\r\n",item.name,saveNum,item.unit];
        }
        else if (TWDiscount == type)
        {
            float itemSave = item.quantity * item.price * (1-kDiscountValue);
            saveCost += itemSave;
            itemTotal = item.quantity * item.price * kDiscountValue;
            [productDetail appendFormat:@"名称:%@,数量:%.0f%@,单价:%.2f(元),小计:%.2f(元),节省%.2f(元)\r\n",item.name,item.quantity,item.unit,item.price,itemTotal,itemSave];
        }
        else
        {
            itemTotal = item.quantity * item.price;
            [productDetail appendFormat:@"名称:%@,数量:%.0f%@,单价:%.2f(元),小计:%.2f(元)\r\n",item.name,item.quantity,item.unit,item.price,itemTotal];
        }
        totalCost += itemTotal;
    }
    NSMutableString *feeDetail = [NSMutableString stringWithString:@"\r\n***<没钱赚商店>购物清单***\r\n"];
    if([productDetail length])
    {
        [feeDetail appendString:productDetail];
    }
    if([freeOneDetail length])
    {
        [feeDetail appendString:@"----------------------\r\n"];
        [feeDetail appendString:@"买二赠一商品:\r\n"];
        [feeDetail appendString:freeOneDetail];
    }
    if(totalCost > 0)
    {
        [feeDetail appendString:@"----------------------\r\n"];
        [feeDetail appendFormat:@"总计:%.2f(元)\r\n",totalCost];
    }
    if(saveCost > 0)
    {
        [feeDetail appendFormat:@"节省:%.2f(元)\r\n",saveCost];
    }
    [feeDetail appendString:@"**********************"];
    NSLog(@"%@",feeDetail);
    _totalFee = totalCost;
    _savedFee = saveCost;
    return feeDetail;
}

- (NSArray<TWProduct*>*)constructProduct:(NSDictionary*)productInfo
{
    NSMutableArray<TWProduct*>*products = [NSMutableArray array];
    [productInfo enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull barCode, NSNumber*  _Nonnull quantity, BOOL * _Nonnull stop) {
        TWProduct* item = [[TWProduct alloc] initWithBarcode:barCode quantity:quantity.floatValue];
        [products addObject:item];
    }];
    return products;
}



@end
