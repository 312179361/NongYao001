//
//  CALayer+LayerColor.m
//  NongYiWenYao
//
//  Created by TongLi on 16/9/9.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "CALayer+LayerColor.h"

@implementation CALayer (LayerColor)
- (void)setBorderColorFromUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
