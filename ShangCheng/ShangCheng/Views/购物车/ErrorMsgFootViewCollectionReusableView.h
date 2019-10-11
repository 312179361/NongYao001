//
//  ErrorMsgFootViewCollectionReusableView.h
//  ShangCheng
//
//  Created by TongLi on 2017/3/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorMsgFootViewCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *errorMsgLabel;


- (void)updateErrorMsgFootViewWithErrorMsg:(NSString *)errorMsg;


@end
