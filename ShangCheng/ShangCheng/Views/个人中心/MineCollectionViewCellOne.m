//
//  MineCollectionViewCellOne.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MineCollectionViewCellOne.h"
#import "Manager.h"
#import "UIButton+ButtonCategory.h"
@implementation MineCollectionViewCellOne
- (void)updateMineCollectionViewCellOne {
    Manager *manager = [Manager shareInstance];
    [self.userHeadButton setImage:[UIImage imageNamed:@"w_icon_mrtx"] forState:UIControlStateNormal];

    self.myNameLabel.text = @"未登录";
    self.myAreaAndPhoneLabel.hidden = YES;
    self.myTypeImageView.hidden = YES;
    self.memberManagerButton.hidden = YES;
    
    if ([manager isLoggedInStatus] == YES) {
        //已经登录了。
        //图片
        [self.userHeadButton setWebImageURLWithImageUrlStr:manager.memberInfoModel.u_icon withErrorImage:[UIImage imageNamed:@"w_icon_mrtx"] ];
        
        

        //姓名
        self.myNameLabel.text = manager.memberInfoModel.u_truename;
        //地址手机号
        self.myAreaAndPhoneLabel.hidden = NO;
        NSString *areaAndPhoneStr = @"" ;
        if (manager.memberInfoModel.capitalname!= nil && manager.memberInfoModel.capitalname.length > 0) {
            areaAndPhoneStr = [areaAndPhoneStr stringByAppendingString:manager.memberInfoModel.capitalname];
            areaAndPhoneStr = [areaAndPhoneStr stringByAppendingString:@" "];
        }
        
        if (manager.memberInfoModel.cityname!= nil && manager.memberInfoModel.cityname.length > 0) {
            areaAndPhoneStr = [areaAndPhoneStr stringByAppendingString:manager.memberInfoModel.cityname];
            areaAndPhoneStr = [areaAndPhoneStr stringByAppendingString:@" "];
        }
        areaAndPhoneStr = [areaAndPhoneStr stringByAppendingString:manager.memberInfoModel.u_mobile];

        self.myAreaAndPhoneLabel.text = areaAndPhoneStr;

        //代理
        if ([manager.memberInfoModel.u_type isEqualToString:@"1"]) {
            //代理商显示，其余的都不显示
            self.myTypeImageView.hidden = NO;
        }
        self.memberManagerButton.hidden = NO;
    }
    
}

@end
