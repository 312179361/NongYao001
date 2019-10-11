//
//  KongImageView.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "KongImageView.h"

@implementation KongImageView
- (void)showKongViewWithKongMsg:(NSString *)msg withKongType:(KongType)kongType {
    self.hidden = NO;
    switch (kongType) {
        case KongTypeWithKongData:
            self.showImageView.image = [UIImage imageNamed:@"s_pic_ksj"];
            self.reloadAgainButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:0];
            self.reloadAgainButton.hidden = YES;
            break;
        case KongTypeWithNetError:
            self.showImageView.image = [UIImage imageNamed:@"s_pic_wlcw"];
            [self.reloadAgainButton setTitle:@"重新加载" forState:UIControlStateNormal];
            self.reloadAgainButton.indexForButton = [NSIndexPath indexPathForRow:1 inSection:0];
            self.reloadAgainButton.hidden = NO;
            break;
        case KongTypeWithSearchKong:
            self.showImageView.image = [UIImage imageNamed:@"s_pic_sswk"];
            self.reloadAgainButton.hidden = YES;
            self.reloadAgainButton.indexForButton = [NSIndexPath indexPathForRow:2 inSection:0];
            break;
        case KongTypeWithKongFavorite:
            self.showImageView.image = [UIImage imageNamed:@"s_pic_zwcc"];
            self.reloadAgainButton.indexForButton = [NSIndexPath indexPathForRow:3 inSection:0];
            self.reloadAgainButton.hidden = YES;
            break;
        case KongTypeWithNotLogin:
            self.showImageView.image = [UIImage imageNamed:@"s_oic_wdl"];
            [self.reloadAgainButton setTitle:@"请登录" forState:UIControlStateNormal];
            self.reloadAgainButton.indexForButton = [NSIndexPath indexPathForRow:4 inSection:0];
            self.reloadAgainButton.hidden = NO;
        default:
            break;
    }
    
    self.showMsgLabel.text = msg;
}

- (void)hiddenKongView {
    self.hidden = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
