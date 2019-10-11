//
//  TodaySaleHeaderCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodaySaleHeaderCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

- (void)updateHeaderCellWithImageUrl:(NSString *)tempImageUrl;
@end
