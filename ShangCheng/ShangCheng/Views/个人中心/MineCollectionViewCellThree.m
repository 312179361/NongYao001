//
//  MineCollectionViewCellThree.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MineCollectionViewCellThree.h"

@implementation MineCollectionViewCellThree
- (void)updateCellWithHeaderStr:(NSString *)headerStr withInfoStr:(NSString *)infoStr {
    if (headerStr != nil && headerStr.length > 0) {
        self.headerLabel.text = headerStr;
    }else{
        self.headerLabel.text = @"--";
    }

    self.infoLabel.text = infoStr;
}

@end
