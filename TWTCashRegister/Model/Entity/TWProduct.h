//
//  TWProduct.h
//  TWTCashRegister
//
//  Created by huixinming on 3/1/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import <Foundation/Foundation.h>

/*商品数据结构，考虑到水果、蔬菜之类的商品应该是称斤的，所以“数量”的类型应该是float，另外条形码、价格之类的信息是不可变得，故而属性设置成"readonly"
 */

@interface TWProduct : NSObject

@property(nonatomic,copy,readonly) NSString* barCode;
@property(nonatomic,copy,readonly) NSString* name;
@property(nonatomic,assign,readonly) float price;
@property(nonatomic,copy,readonly) NSString* category;
@property(nonatomic,copy,readonly) NSString* unit;
@property(nonatomic,assign) float quantity;

- (instancetype)initWithBarcode:(NSString*)barCode quantity:(float)quantity;

@end
