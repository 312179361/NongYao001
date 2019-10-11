//
//  ErrorMsgFootViewCollectionReusableView.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ErrorMsgFootViewCollectionReusableView.h"

@implementation ErrorMsgFootViewCollectionReusableView
- (void)updateErrorMsgFootViewWithErrorMsg:(NSString *)errorMsg {
    self.errorMsgLabel.text = errorMsg;
}

@end
