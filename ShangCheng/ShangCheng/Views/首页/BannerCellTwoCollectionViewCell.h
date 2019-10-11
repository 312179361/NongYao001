//
//  BannerCellTwoCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/11/20.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityProductModel.h"
@interface BannerCellTwoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productFactoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *productStandardLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel; //活动价
@property (weak, nonatomic) IBOutlet UILabel *backPriceLabel; //原价

@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;//销量


@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;

- (void)updateBannerShopTwoCellWithActivityModel:(ActivityProductModel *)activityModel;
@end
