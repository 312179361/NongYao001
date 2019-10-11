//
//  UIImageView+ImageViewCategory.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/20.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
@interface UIImageView (ImageViewCategory)

- (void)setWebImageURLWithImageUrlStr:(NSString *)imageUrlStr withErrorImage:(UIImage *)errorImage withIsCenter:(BOOL)isCenter ;


@end
