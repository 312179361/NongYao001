//
//  MineAddressTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MineAddressTableViewCell.h"

@implementation MineAddressTableViewCell
- (void)updateMineAddressCellWithModel:(ReceiveAddressModel *)addressModel {
    
    if (addressModel.receiveMobile.length > 0) {
        self.nameAndPhoneLabel.text = [NSString stringWithFormat:@"%@  %@",addressModel.receiverName,addressModel.receiveMobile];
    }else {
        self.nameAndPhoneLabel.text = [NSString stringWithFormat:@"%@  未知电话",addressModel.receiverName];
    }
    
    NSString *detailAddressStr = @"" ;
    if (addressModel.capitalname!= nil && addressModel.capitalname.length > 0) {
        detailAddressStr = [detailAddressStr stringByAppendingString:addressModel.capitalname];
        detailAddressStr = [detailAddressStr stringByAppendingString:@" "];
    }

    if (addressModel.cityname!= nil && addressModel.cityname.length > 0) {
        detailAddressStr = [detailAddressStr stringByAppendingString:addressModel.cityname];
        detailAddressStr = [detailAddressStr stringByAppendingString:@" "];
    }
    
    if (addressModel.countyname!= nil && addressModel.countyname.length > 0) {
        detailAddressStr = [detailAddressStr stringByAppendingString:addressModel.countyname];
        detailAddressStr = [detailAddressStr stringByAppendingString:@" "];
    }
    
    if (addressModel.receiveAddress!= nil && addressModel.receiveAddress.length > 0) {
        detailAddressStr = [detailAddressStr stringByAppendingString:addressModel.receiveAddress];
        detailAddressStr = [detailAddressStr stringByAppendingString:@" "];
    }
    
    
    self.detailAddressLabel.text = detailAddressStr;
    
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
