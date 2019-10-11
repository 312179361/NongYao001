//
//  ProductDetailTwoTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/4/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailTwoTableViewCell : UITableViewCell<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;

@property (nonatomic,assign)CGFloat documentHeight;

- (void)updateProductDetailTwoCell:(NSString *)webIntroduce;

@end
