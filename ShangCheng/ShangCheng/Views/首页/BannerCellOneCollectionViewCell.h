//
//  BannerCellOneCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/11/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchBlock)(NSString *searchStr);

@interface BannerCellOneCollectionViewCell : UICollectionViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (nonatomic,copy)SearchBlock searchBlock;

//- (void)searchBlockAction:(SearchBlock)searchBlockaaa;
- (void)updateBannerCellWithImageUrl:(NSString *)imageUrl;
@end
