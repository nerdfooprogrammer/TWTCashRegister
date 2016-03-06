//
//  TWParse.m
//  TWTCashRegister
//
//  Created by huixinming on 2/29/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import "TWParse.h"

@implementation TWParse

+ (NSDictionary*)parseProductList:(NSArray<NSString*>*)lists
{
    if(![lists isKindOfClass:[NSArray class]])
    {
        NSLog(@"商品输入信息格式不正确!!!");
        return nil;
    }
    NSMutableDictionary *productList = [NSMutableDictionary dictionary];
    for (NSString*element in lists) {
        NSDictionary *item = [self splitProductInfo:element];
        NSArray<NSString*>*keys = [item allKeys];
        for (NSString*key in keys) {
            NSNumber *quantity = [productList objectForKey:key];
            if(nil != quantity)
            {
                NSNumber *tmpNum = (NSNumber*)[item objectForKey:key];
                quantity = [NSNumber numberWithFloat:(tmpNum.floatValue+quantity.floatValue)];
            }
            else
            {
                quantity = [item objectForKey:key];
            }
            [productList setObject:quantity forKey:key];
        }
    }
    return productList;
}

+ (NSDictionary*)splitProductInfo:(NSString*)productInfo
{
    NSMutableDictionary *item = [NSMutableDictionary dictionary];
    float quantity = 0.0;
    NSArray<NSString *> *elements = [productInfo componentsSeparatedByString:@"-"];
    if(1 == [elements count])
    {
        quantity = 1.0;
    }
    else
    {
        quantity = elements[1].floatValue;
    }
    [item setObject:[NSNumber numberWithFloat:quantity] forKey:elements[0]];
    return item;
}

@end
