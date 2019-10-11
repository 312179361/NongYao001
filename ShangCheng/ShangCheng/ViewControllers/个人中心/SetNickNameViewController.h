//
//  SetNickNameViewController.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/10.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FreshNewNameBlock)();
@interface SetNickNameViewController : UIViewController
@property (nonatomic,copy)FreshNewNameBlock freshNewNameBlock;
@end
