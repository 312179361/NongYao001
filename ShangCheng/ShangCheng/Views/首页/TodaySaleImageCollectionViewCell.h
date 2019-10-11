//
//  TodaySaleImageCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodaySaleImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *todayBannerSaleImgView;

- (void)updateTodayBannerImg:(NSString *)imgStr;
@end
