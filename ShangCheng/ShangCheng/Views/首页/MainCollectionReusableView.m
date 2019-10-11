//
//  MainCollectionReusableView.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MainCollectionReusableView.h"

@implementation MainCollectionReusableView

- (void)updateMainHomeCell:(NSString *)sectionTitleStr withSection:(NSInteger )sectionIndex {

//    self.sectionTitleLabe.text = sectionTitleStr;
//    NSLog(@"--%@ ",sectionTitleStr);
    if ([sectionTitleStr isEqualToString:@"杀虫剂"]) {
        self.titleImageView.image = [UIImage imageNamed:@"s_font_scj"];
    }
    if ([sectionTitleStr isEqualToString:@"杀螨剂"]) {
        self.titleImageView.image = [UIImage imageNamed:@"s_font_smj"];
    }
    if ([sectionTitleStr isEqualToString:@"除草剂"]) {
        self.titleImageView.image = [UIImage imageNamed:@"s_font_ccj"];
    }
    if ([sectionTitleStr isEqualToString:@"调节剂"]) {
        self.titleImageView.image = [UIImage imageNamed:@"s_font_tjj"];
    }
    if ([sectionTitleStr isEqualToString:@"叶面肥"]) {
        self.titleImageView.image = [UIImage imageNamed:@"s_font_tmf"];
    }
    if ([sectionTitleStr isEqualToString:@"杀菌剂"]) {
        self.titleImageView.image = [UIImage imageNamed:@"s_font_sjj"];
    }
    if ([sectionTitleStr isEqualToString:@"其它"]) {
        self.titleImageView.image = [UIImage imageNamed:@"s_font_qt"];
    }
    
    self.moreButtonForMainCell.indexForButton = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
    
}

- (IBAction)moreButtonForMainCell:(IndexButton *)sender {
    NSLog(@"%ld",sender.indexForButton.section);
    self.morebuttonIndexBlock(sender.indexForButton.section);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
