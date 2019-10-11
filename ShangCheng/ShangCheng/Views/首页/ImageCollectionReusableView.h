//
//  ImageCollectionReusableView.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
@interface ImageCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet SDCycleScrollView *imageScrollView;

- (void)updateImageCellWithImgUrlArr:(NSArray *)imgUrlArr;

@end
