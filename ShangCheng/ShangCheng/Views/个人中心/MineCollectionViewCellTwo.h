//
//  MineCollectionViewCellTwo.h
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCollectionViewCellTwo : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

- (void)updateCellWithHeaderImage:(NSString *)headerImageUrl withInfoStr:(NSString *)infoStr withFontFloat:(CGFloat)fontFloat withLineViewHide:(BOOL)lineViewHide withCount:(NSString *)count ;
@end
