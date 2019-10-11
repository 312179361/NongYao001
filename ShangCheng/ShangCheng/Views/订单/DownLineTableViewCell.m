//
//  DownLineTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/18.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "DownLineTableViewCell.h"

@implementation DownLineTableViewCell

- (void)updateBankUIWithBankDic:(NSMutableDictionary *)bankDic {
    self.bankImageView.image = [UIImage imageNamed:[bankDic objectForKey:@"img"]];
    self.bankNameLabel.text = [bankDic objectForKey:@"bankName"];
    self.bankCarNumberLabel.text = [NSString stringWithFormat:@"卡号：%@", [bankDic objectForKey:@"bankNumber"] ];
    
    if ([[bankDic objectForKey:@"isSelect"] isEqualToString:@"YES"]) {
        self.selectMarkImageView.image = [UIImage imageNamed:@"g_btn_select"];
    }else {
        self.selectMarkImageView.image = [UIImage imageNamed:@"g_btn_normal"];

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
