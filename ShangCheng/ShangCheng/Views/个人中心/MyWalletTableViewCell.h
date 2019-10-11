//
//  MyWalletTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/7.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myWalletIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *myWalletTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *myWalletRightLabel;

- (void)updateMyWalletCellWithDataJson:(NSDictionary *)dataJson;

@end
