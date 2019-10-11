//
//  AddReceiveAddressViewController.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/30.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"

typedef void(^RefreshAddressList)(NSString *motifyOrAddModelID);
@interface AddReceiveAddressViewController : UIViewController
@property (nonatomic,strong)ReceiveAddressModel *tempReceiveAddressModel;
@property (nonatomic,copy)RefreshAddressList refreshAddressListBlock;

@end
