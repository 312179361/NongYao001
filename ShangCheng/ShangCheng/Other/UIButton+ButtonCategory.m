//
//  UIButton+ButtonCategory.m
//  ShangCheng
//
//  Created by TongLi on 2017/12/19.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "UIButton+ButtonCategory.h"
#import "UIButton+WebCache.h"

@implementation UIButton (ButtonCategory)
- (void)setWebImageURLWithImageUrlStr:(NSString *)imageUrlStr withErrorImage:(UIImage *)errorImage {
    Manager *manager = [Manager shareInstance];
    //    NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
    //    NSLog(@"-----%@",imageUrl);
    NSURL *imageUrl = [manager webImageURlWith:imageUrlStr];
    self.contentMode = UIViewContentModeScaleToFill;
    
    [self sd_setImageWithURL:imageUrl forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error != nil) {
            [self setImage:errorImage forState:UIControlStateNormal];
        }
    }];
    
}
@end
