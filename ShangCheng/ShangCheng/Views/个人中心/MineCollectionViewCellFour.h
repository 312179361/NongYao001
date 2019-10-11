//
//  MineCollectionViewCellFour.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCollectionViewCellFour : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

- (void)updateCellWithInfoStr1:(NSString *)infoStr1 withInfoStr2:(NSString *)infoStr2;

@end
