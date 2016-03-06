//
//  TWCashRegister.h
//  TWTCashRegister
//
//  Created by huixinming on 3/1/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import <Foundation/Foundation.h>

/*结算类，负责计算详细费用，其中"totalFee"、"savedFee"两个属性是为了配合测试用例增加的
 */

@interface TWCashRegister : NSObject

@property(nonatomic,assign,readonly) float totalFee;
@property(nonatomic,assign,readonly) float savedFee;

- (NSString*)clearingFee:(NSArray<NSString*>*)productList;

@end
