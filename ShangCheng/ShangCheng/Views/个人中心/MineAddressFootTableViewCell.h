//
//  MineAddressFootTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/1/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"
#import "ReceiveAddressModel.h"
@interface MineAddressFootTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet IndexButton *defaultAddressButton;
@property (weak, nonatomic) IBOutlet IndexButton *editAddressButton;
@property (weak, nonatomic) IBOutlet IndexButton *deleteAddressButton;



- (void)updateMineAddressFootCellWithModel:(ReceiveAddressModel *)addressModel ;

@end
