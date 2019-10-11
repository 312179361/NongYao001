//
//  BannerShopCollectionReusableView.h
//  ShangCheng
//
//  Created by TongLi on 2017/11/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"
typedef void(^MoreButtonBlock)(NSInteger btnIndex);

@interface BannerShopCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *titleImgView;
@property (weak, nonatomic) IBOutlet IndexButton *moreButton;

@property(nonatomic,copy)MoreButtonBlock moreButtonBlock;

- (void)updateBannerHeadViewWithTempSection:(NSInteger)tempSection withTotalSection:(NSInteger)totalSection;

@end
