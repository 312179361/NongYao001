//
//  AfterMarketTwoTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/22.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupOrderModel.h"
@interface AfterMarketTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *productImageViewTwo;
@property (weak, nonatomic) IBOutlet UIImageView *productImageViewThree;
@property (weak, nonatomic) IBOutlet UIImageView *productImageViewFour;

- (void)updateAfterMarketTwoCellWithModel:(SupOrderModel *)tempModel;




@end
