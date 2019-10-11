//
//  BannerCellOneCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/11/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "BannerCellOneCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation BannerCellOneCollectionViewCell
- (void)updateBannerCellWithImageUrl:(NSString *)imageUrl {
    [self.bannerImageView setWebImageURLWithImageUrlStr:imageUrl withErrorImage:[UIImage imageNamed:@"banner.png"] withIsCenter:NO];
}



- (IBAction)searchButtonAction:(UIButton *)sender {
    if (self.searchTextField != nil && self.searchTextField.text.length > 0) {
        self.searchBlock(self.searchTextField.text);

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (self.searchTextField != nil && self.searchTextField.text.length > 0) {
        self.searchBlock(self.searchTextField.text);
        
    }
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
