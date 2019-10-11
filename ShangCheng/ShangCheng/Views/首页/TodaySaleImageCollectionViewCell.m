//
//  TodaySaleImageCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "TodaySaleImageCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation TodaySaleImageCollectionViewCell
- (void)updateTodayBannerImg:(NSString *)imgStr {
    [self.todayBannerSaleImgView setWebImageURLWithImageUrlStr:imgStr withErrorImage:[UIImage imageNamed:@"todaySale.png"] withIsCenter:NO];
}

@end
