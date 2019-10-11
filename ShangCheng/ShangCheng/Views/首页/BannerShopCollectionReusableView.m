//
//  BannerShopCollectionReusableView.m
//  ShangCheng
//
//  Created by TongLi on 2017/11/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "BannerShopCollectionReusableView.h"

@implementation BannerShopCollectionReusableView
- (void)updateBannerHeadViewWithTempSection:(NSInteger)tempSection withTotalSection:(NSInteger)totalSection {
    
    NSArray *imgArr = @[@"",@"s_font_scj_2",@"s_font_smj_2",@"s_font_sjj_2",@"s_font_ccj_2",
                        @"s_font_tjj_2",@"s_font_tmf_2",@"s_font_qt_2",@"s_font_cycj_2",@"s_font_jyjl_2"];

    
    if (tempSection == totalSection-1 || tempSection == totalSection-2) {
        self.moreButton.hidden = YES;
    }else {
        self.moreButton.hidden = NO;
    }
    
    if (tempSection > 0) {
        self.titleImgView.image = [UIImage imageNamed:imgArr[tempSection]];
        self.moreButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:tempSection-1];
    }
}

//更多
- (IBAction)moreButtonAction:(IndexButton *)sender {
    
    self.moreButtonBlock(sender.indexForButton.section);
}


@end
