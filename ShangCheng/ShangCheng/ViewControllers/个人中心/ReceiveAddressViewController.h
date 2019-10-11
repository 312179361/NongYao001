//
//  ReceiveAddressViewController.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/29.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveAddressModel.h"

typedef void(^SelectModelBlock)();

@interface ReceiveAddressViewController : UIViewController

@property (nonatomic,copy)SelectModelBlock selectModelBlock;

@end
