//
//  TWParse.h
//  TWTCashRegister
//
//  Created by huixinming on 2/29/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import <Foundation/Foundation.h>

/*解析输入信息，把['ITEM000001','ITEM000001','ITEM000002']转成
  {'ITEM000001':2,'ITEM000002':1}(该类算是本项目中最核心的部分了)
 */

@interface TWParse : NSObject

+ (NSDictionary*)parseProductList:(NSArray<NSString*>*)lists;

@end
