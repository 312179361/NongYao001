//
//  MineAddressTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/1/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveAddressModel.h"
@interface MineAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameAndPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;

- (void)updateMineAddressCellWithModel:(ReceiveAddressModel *)addressModel;
@end
