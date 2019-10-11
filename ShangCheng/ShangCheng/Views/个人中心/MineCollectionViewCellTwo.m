//
//  MineCollectionViewCellTwo.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MineCollectionViewCellTwo.h"

@implementation MineCollectionViewCellTwo

- (void)updateCellWithHeaderImage:(NSString *)headerImageUrl withInfoStr:(NSString *)infoStr withFontFloat:(CGFloat)fontFloat withLineViewHide:(BOOL)lineViewHide withCount:(NSString *)count {
    self.headerImageView.image = [UIImage imageNamed:headerImageUrl];
    self.infoLabel.text = infoStr;
    self.infoLabel.font = [UIFont systemFontOfSize:fontFloat];

    self.lineView.hidden = lineViewHide;
    
    if (![count isEqualToString:@"0"]) {
        self.countLabel.hidden = NO;
        self.countLabel.text = count;
    }else {
        self.countLabel.hidden = YES;
    }
    
}

@end
