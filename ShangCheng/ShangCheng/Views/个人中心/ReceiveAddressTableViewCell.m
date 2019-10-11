//
//  ReceiveAddressTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/29.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ReceiveAddressTableViewCell.h"

@implementation ReceiveAddressTableViewCell
- (void)updateReceiveAddressCell:(ReceiveAddressModel *)receiveAddressModel withIndex:(NSIndexPath *)cellIndex{
    //给button附上index
    self.leftSelectButton.indexForButton = cellIndex;

    NSString *phoneStr = @"";
    if (receiveAddressModel.receiveMobile != nil && receiveAddressModel.receiveMobile.length == 11) {
        phoneStr = receiveAddressModel.receiveMobile;
    }
    
    self.receiverAndMobileLabel.text = [NSString stringWithFormat:@"%@  %@",receiveAddressModel.receiverName,phoneStr];
    
    NSString *detailAddressStr = @"" ;
    if (receiveAddressModel.capitalname!= nil && receiveAddressModel.capitalname.length > 0) {
        detailAddressStr = [detailAddressStr stringByAppendingString:receiveAddressModel.capitalname];
        detailAddressStr = [detailAddressStr stringByAppendingString:@" "];
    }
    
    if (receiveAddressModel.cityname!= nil && receiveAddressModel.cityname.length > 0) {
        detailAddressStr = [detailAddressStr stringByAppendingString:receiveAddressModel.cityname];
        detailAddressStr = [detailAddressStr stringByAppendingString:@" "];
    }
    
    if (receiveAddressModel.countyname!= nil && receiveAddressModel.countyname.length > 0) {
        detailAddressStr = [detailAddressStr stringByAppendingString:receiveAddressModel.countyname];
        detailAddressStr = [detailAddressStr stringByAppendingString:@" "];
    }
    
    if (receiveAddressModel.receiveAddress!= nil && receiveAddressModel.receiveAddress.length > 0) {
        detailAddressStr = [detailAddressStr stringByAppendingString:receiveAddressModel.receiveAddress];
        detailAddressStr = [detailAddressStr stringByAppendingString:@" "];
    }
    
    
    self.receiveAddressLabel.text = detailAddressStr;

    if (receiveAddressModel.isSelect == YES) {
        [self.leftSelectButton setImage:[UIImage imageNamed:@"g_icon_select"] forState:UIControlStateNormal];
    }else {
        [self.leftSelectButton setImage:[UIImage imageNamed:@"g_icon_normal"] forState:UIControlStateNormal];

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
