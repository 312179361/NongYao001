//
//  MineAddressFootTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MineAddressFootTableViewCell.h"

@implementation MineAddressFootTableViewCell

- (void)updateMineAddressFootCellWithModel:(ReceiveAddressModel *)addressModel {
    
    if (addressModel.defaultAddress == YES) {
        [self.defaultAddressButton setImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];

    }else {
        [self.defaultAddressButton setImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];


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
