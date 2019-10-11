//
//  UIImageView+ImageViewCategory.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/20.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "UIImageView+ImageViewCategory.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (ImageViewCategory)
- (void)setWebImageURLWithImageUrlStr:(NSString *)imageUrlStr withErrorImage:(UIImage *)errorImage withIsCenter:(BOOL)isCenter {
    Manager *manager = [Manager shareInstance];
//    NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
//    NSLog(@"-----%@",imageUrl);
    NSURL *imageUrl = [manager webImageURlWith:imageUrlStr];
    self.contentMode = UIViewContentModeScaleToFill;
    [self sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error != nil) {
            if (isCenter == YES) {
                self.contentMode = UIViewContentModeCenter;
            }
            NSLog(@"++%@",imageUrl);
            self.image = errorImage;
        }
    }];
}

@end
