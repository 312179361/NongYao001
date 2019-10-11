//
//  PlaceholdTextView.m
//  textViewPlacehold
//
//  Created by TongLi on 16/9/26.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "PlaceholdTextView.h"
@interface PlaceholdTextView ()<UITextViewDelegate>

@end
@implementation PlaceholdTextView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addPlacehold];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addPlacehold];
        
    }
    return self;
}

- (void)addPlacehold {
    
    
    self.holdLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 0, 280, 30)];

    self.holdLabel.font = self.font;
    self.holdLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [self addSubview:self.holdLabel];
    
    
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.holdLabel.text = self.textViewPlacehold;
    }else{
        self.holdLabel.text = @"";
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.holdLabel.text = self.textViewPlacehold;
    [self textViewDidChange:self];
    if (self.isAddDelegate == YES) {
        self.delegate = self;
    }
}



@end
