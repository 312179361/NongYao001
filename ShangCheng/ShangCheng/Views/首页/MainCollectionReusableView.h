//
//  MainCollectionReusableView.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"

typedef void(^MoreButtonBlock)(NSInteger moreButtonBlock);
@interface MainCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet IndexButton *moreButtonForMainCell;
//block 、
@property (nonatomic,copy)MoreButtonBlock morebuttonIndexBlock;

- (void)updateMainHomeCell:(NSString *)sectionTitleStr withSection:(NSInteger )sectionIndex;
@end
