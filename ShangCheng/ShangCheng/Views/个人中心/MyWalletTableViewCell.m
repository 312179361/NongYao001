//
//  MyWalletTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/7.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyWalletTableViewCell.h"

@implementation MyWalletTableViewCell

- (void)updateMyWalletCellWithDataJson:(NSDictionary *)dataJson {
    
    self.myWalletIconImageView.image = [UIImage imageNamed:[dataJson objectForKey:@"myWalletImg"]];
    self.myWalletTitleLabel.text = [dataJson objectForKey:@"myWalletTitle"];
    if ([dataJson objectForKey:@"myWalletRight"] != nil) {
        self.myWalletRightLabel.text = [dataJson objectForKey:@"myWalletRight"];

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
