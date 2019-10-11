//
//  ProductDetailFourTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/16.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductTradeRecordModel.h"
@interface ProductDetailFourTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)updateProductDetailFourCellWithModel:(ProductTradeRecordModel *)model ;

@end
