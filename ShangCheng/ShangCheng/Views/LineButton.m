//
//  LineButton.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/6.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "LineButton.h"
@interface LineButton ()
@property (nonatomic,strong)UIView *lineView;

@end

@implementation LineButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addLineView];
    }
    return self;
}

- (void)addLineView {
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-2, self.bounds.size.width, 2)];
    self.lineView.backgroundColor = self.lineColor;
    [self addSubview:self.lineView];
    
}

- (void)setLineColor:(UIColor *)lineColor {
    self.lineView.backgroundColor = lineColor;
}


@end
