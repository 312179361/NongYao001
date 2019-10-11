//
//  TodaySaleHeaderCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "TodaySaleHeaderCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation TodaySaleHeaderCollectionViewCell
- (void)updateHeaderCellWithImageUrl:(NSString *)tempImageUrl {
    [self.headerImageView setWebImageURLWithImageUrlStr:tempImageUrl withErrorImage:[UIImage imageNamed:@"icon_pic_cp.png"] withIsCenter:YES];
}

@end
