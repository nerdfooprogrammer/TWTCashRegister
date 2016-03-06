//
//  TWFavorable.h
//  TWTCashRegister
//
//  Created by huixinming on 3/1/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,TWFavorableType){
    TWNONE,
    TWFreeOne,
    TWDiscount,
};

/*商品优惠类型检测(通过查询数据库中优惠表得知)
 */
@interface TWFavorable : NSObject

+ (TWFavorableType)checkFavorableType:(NSString*)barCode;

@end
