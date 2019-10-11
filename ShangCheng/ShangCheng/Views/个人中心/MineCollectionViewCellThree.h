//
//  MineCollectionViewCellThree.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCollectionViewCellThree : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

- (void)updateCellWithHeaderStr:(NSString *)headerStr withInfoStr:(NSString *)infoStr;
@end
