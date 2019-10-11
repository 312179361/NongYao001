//
//  MyAgentCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/12/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyAgentCollectionViewCell.h"

@implementation MyAgentCollectionViewCell
- (void)updateMyAgentCollectionCellWithDataDic:(NSMutableDictionary *)dataDic {

    self.iconImageView.image = [UIImage imageNamed:[dataDic objectForKey:@"img"]];
    self.iconTitleLabel.text = [dataDic objectForKey:@"title"];
    
    if ([[dataDic objectForKey:@"detail"] isEqualToString:@"0"]) {
        self.iconDetailLabel.hidden = YES;
    }else {
        self.iconDetailLabel.hidden = NO;
        self.iconDetailLabel.text = [dataDic objectForKey:@"detail"];

    }
    
    
    
}

@end
