//
//  PestsCollectionReusableView.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "PestsCollectionReusableView.h"

@implementation PestsCollectionReusableView
- (void)updateRightHeaderViewWithModel:(PestsTreeModel *)tempClassModel {
    self.rightHeaderLabel.text = tempClassModel.c_name;
    
    if (tempClassModel.itemArr.count > 6) {
        self.rightHeaderButton.hidden = NO;
    }else {
        self.rightHeaderButton.hidden = YES;
    }
    
    
    if (tempClassModel.isMore == YES) {
        //已经点开了更多
        [self.rightHeaderButton setTitle:@"收回" forState:UIControlStateNormal];
    }else {
        [self.rightHeaderButton setTitle:@"更多" forState:UIControlStateNormal];
        
    }
    
}
- (IBAction)rightMoreButtonAction:(IndexButton *)sender {
    
    self.moreButtonIndex(sender.indexForButton);
    
    
}

@end
