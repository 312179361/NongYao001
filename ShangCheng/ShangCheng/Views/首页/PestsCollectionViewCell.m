//
//  PestsCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "PestsCollectionViewCell.h"

@implementation PestsCollectionViewCell
- (void)updateRightCellWithTitle:(NSString *)titleStr {
    self.rightCellLabel.text = titleStr;
}
@end
