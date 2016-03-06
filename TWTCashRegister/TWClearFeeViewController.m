//
//  TWClearFeeViewController.m
//  TWTCashRegister
//
//  Created by huixinming on 3/3/16.
//  Copyright © 2016 huixinming. All rights reserved.
//

#import "TWClearFeeViewController.h"

@interface TWClearFeeViewController ()

@end

@implementation TWClearFeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _feeDetailTextView.text = _feeDetail;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setFeeDetail:(NSString*)feeDetail
{
    _feeDetail = feeDetail;
}

@end
