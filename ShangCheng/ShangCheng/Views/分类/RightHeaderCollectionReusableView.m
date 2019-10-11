//
//  RightHeaderCollectionReusableView.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "RightHeaderCollectionReusableView.h"

@implementation RightHeaderCollectionReusableView
- (void)updateRightHeaderViewWithModel:(ClassModel *)tempClassModel {
    self.rightHeaderLabel.text = tempClassModel.d_value;
    
    if (tempClassModel.subItemArr.count > 6) {
        self.rightHeaderButton.hidden = NO;
    }else {
        self.rightHeaderButton.hidden = YES;
    }
    
    
    if (tempClassModel.isMore == YES) {
        //已经点开了更多
        [self.rightHeaderButton setTitle:@"收回" forState:UIControlStateNormal];
        [self.rightHeaderButton setImage:[UIImage imageNamed:@"s_icon_shouhui"] forState:UIControlStateNormal];

    }else {
        [self.rightHeaderButton setTitle:@"更多" forState:UIControlStateNormal];
        [self.rightHeaderButton setImage:[UIImage imageNamed:@"s_icon_into"] forState:UIControlStateNormal];



    }
    
    

    
}
- (IBAction)rightMoreButtonAction:(IndexButton *)sender {
    
    self.moreButtonIndex(sender.indexForButton);
    
    
}

@end
