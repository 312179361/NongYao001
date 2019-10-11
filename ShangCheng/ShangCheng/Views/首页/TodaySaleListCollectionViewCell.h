//
//  TodaySaleListCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodaySaleListModel.h"
@interface TodaySaleListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *todaySaleListImageView;
@property (weak, nonatomic) IBOutlet UIImageView *saleImageView;

@property (weak, nonatomic) IBOutlet UILabel *todaySaleListTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *todaySaleListFormatLabel;
@property (weak, nonatomic) IBOutlet UILabel *todaySaleListSaleVolLabel;

@property (weak, nonatomic) IBOutlet UILabel *todaySaleListPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *todaySaleListOldPriceLabel;

- (void)updateTodaySaleListCellWithModel:(TodaySaleListModel *)tempModel;


@end
