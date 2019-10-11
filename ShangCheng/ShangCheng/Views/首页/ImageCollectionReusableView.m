//
//  ImageCollectionReusableView.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ImageCollectionReusableView.h"
#import "Manager.h"
@implementation ImageCollectionReusableView
- (void)updateImageCellWithImgUrlArr:(NSArray *)imgUrlArr {
    //设置一下属性

    self.imageScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //    cycleScrollView2.titlesGroup = titles;
    self.imageScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    
    Manager *manager = [Manager shareInstance];
    NSMutableArray *tempUrlArr = [NSMutableArray array];
    for (NSString *tempUrl in imgUrlArr) {
        [tempUrlArr addObject:[manager webImageURlWith:tempUrl]];
    }
    
    self.imageScrollView.imageURLStringsGroup = tempUrlArr;
    //图片的填充样式
    self.imageScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
