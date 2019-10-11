//
//  TradeDetailViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/17.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "TradeDetailViewController.h"

@interface TradeDetailViewController ()

//header
@property (weak, nonatomic) IBOutlet UILabel *bankTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerCurrentProgressLabel;

//账单类型
@property (weak, nonatomic) IBOutlet UILabel *tradeTypeLabel;
//处理进度
@property (weak, nonatomic) IBOutlet UILabel *currentProgressLabel;
//另一种会给你处理进度 分三步
@property (weak, nonatomic) IBOutlet UIImageView *progressOneImageView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabelOne;
@property (weak, nonatomic) IBOutlet UIView *progressLineOne;
@property (weak, nonatomic) IBOutlet UIImageView *progressTwoImageView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabelTwo;
@property (weak, nonatomic) IBOutlet UIView *progressLineTwo;
@property (weak, nonatomic) IBOutlet UIImageView *progressThreeImageView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabelThree;

//第三块的标题
@property (weak, nonatomic) IBOutlet UILabel *threeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeDetailLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeDetailLabel;

@end

@implementation TradeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
