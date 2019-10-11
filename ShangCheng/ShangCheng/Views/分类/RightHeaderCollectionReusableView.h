//
//  RightHeaderCollectionReusableView.h
//  ShangCheng
//
//  Created by TongLi on 2017/1/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
#import "IndexButton.h"

typedef void(^MoreButtonIndex)(NSIndexPath *moreButtonIndex);
@interface RightHeaderCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *rightHeaderLabel;
@property (weak, nonatomic) IBOutlet IndexButton *rightHeaderButton;
@property (nonatomic,copy) MoreButtonIndex moreButtonIndex;


- (void)updateRightHeaderViewWithModel:(ClassModel *)tempClassModel;

@end
