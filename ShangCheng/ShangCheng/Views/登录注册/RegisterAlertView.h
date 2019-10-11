//
//  RegisterAlertView.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/4.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ToRegisterVCStr)(NSString *toRegisterVCStr);

@interface RegisterAlertView : UIView
@property(nonatomic,strong) ToRegisterVCStr toRegisterVCStr;
@end
