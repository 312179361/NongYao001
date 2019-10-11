//
//  AfterMarketTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/1/11.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfterOrderModel.h"
@interface AfterMarketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderProductImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderProductNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderProductCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderProductFormatLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderProductPriceLabel;


- (void)updateAfterMarketCellWithOrderModel:(AfterOrderModel *)tempModel ;

@end
