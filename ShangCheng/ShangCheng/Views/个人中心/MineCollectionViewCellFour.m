//
//  MineCollectionViewCellFour.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MineCollectionViewCellFour.h"

@implementation MineCollectionViewCellFour

- (void)updateCellWithInfoStr1:(NSString *)infoStr1 withInfoStr2:(NSString *)infoStr2 {
    self.infoLabel.text = [NSString stringWithFormat:@"%@:%@",infoStr1,infoStr2];
}

@end
