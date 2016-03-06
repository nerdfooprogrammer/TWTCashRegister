//
//  TWClearFeeViewController.h
//  TWTCashRegister
//
//  Created by huixinming on 3/3/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWClearFeeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *feeDetailTextView;

@property(nonatomic,copy)NSString *feeDetail;

@end
