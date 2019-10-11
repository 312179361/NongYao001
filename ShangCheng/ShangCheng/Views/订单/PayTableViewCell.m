//
//  PayTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/13.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "PayTableViewCell.h"

@implementation PayTableViewCell
- (void)updatePayCellWithJsonDic:(NSDictionary *)jsonDic withShowSelectPayKind:(BOOL)isShow {
//    [jsonDic objectForKey:@"payImg"];
    self.payCellImageView.image = [UIImage imageNamed:[jsonDic objectForKey:@"payImg"]];
    
    self.payCellTitleLabel.text = [jsonDic objectForKey:@"payTitle"];
    
    if (isShow == YES) {
        //选择了这个支付方式
        self.selectMarkImageView.image = [UIImage imageNamed:@"g_btn_select"];
//        self.selectMarkImageView.backgroundColor = [UIColor redColor];
    }else {
        self.selectMarkImageView.image = [UIImage imageNamed:@"g_btn_normal"];

//        self.selectMarkImageView.backgroundColor = [UIColor whiteColor];
    }
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
