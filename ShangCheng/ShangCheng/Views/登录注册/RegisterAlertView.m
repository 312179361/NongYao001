//
//  RegisterAlertView.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/4.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "RegisterAlertView.h"

@implementation RegisterAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)dismissAlertAction:(UIButton *)sender {
    
    self.hidden = YES;
}
//普通用户注册
- (IBAction)generalRegisterAction:(UIButton *)sender {
    self.toRegisterVCStr(@"generalVC");
    self.hidden = YES;
}
//供应商注册
- (IBAction)supplierRegisterAction:(UIButton *)sender {
    self.toRegisterVCStr(@"supplierVC");

    self.hidden = YES;
}




@end
