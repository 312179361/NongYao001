//
//  LineButton.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/6.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineButton : UIButton

@property (nonatomic,strong)IBInspectable UIColor *lineColor;

- (void)setLineColor:(UIColor *)lineColor;

@end
