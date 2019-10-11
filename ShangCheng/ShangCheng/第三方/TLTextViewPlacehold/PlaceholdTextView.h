//
//  PlaceholdTextView.h
//  textViewPlacehold
//
//  Created by TongLi on 16/9/26.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholdTextView : UITextView
@property (nonatomic,strong)IBInspectable NSString *textViewPlacehold;
@property (nonatomic,assign)IBInspectable BOOL isAddDelegate;
@property (nonatomic,strong)UILabel *holdLabel;

@end
