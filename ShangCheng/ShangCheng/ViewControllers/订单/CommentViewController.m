//
//  CommentViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "CommentViewController.h"
#import "Manager.h"
#import "UIImageView+ImageViewCategory.h"
#import "SVProgressHUD.h"
#import "PlaceholdTextView.h"
@interface CommentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *productFormatLabel;

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFive;

//选择的星星数量
@property (nonatomic,assign) NSInteger selectStarCount;

@property (weak, nonatomic) IBOutlet PlaceholdTextView *commentTextView;

//是否匿名评价
@property (nonatomic,assign)BOOL isNickNameComment;
@end

@implementation CommentViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //更新头部视图
    [self updateHeaderProductView];
    //默认是匿名评价
    self.isNickNameComment = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
}

#pragma mark - 刷新头部产品的UI -
- (void)updateHeaderProductView {
    [self.productImageView setWebImageURLWithImageUrlStr:self.tempSonOrderModel.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    self.productTitleLabel.text = self.tempSonOrderModel.p_name;
    self.productFormatLabel.text = [NSString stringWithFormat:@"规格:%@  数量:%@",self.tempSonOrderModel.productst,self.tempSonOrderModel.o_num];
}

#pragma mark - 选择星星数量 -
- (IBAction)buttonOneAction:(UIButton *)sender {
    self.selectStarCount = 1;
    [self updateStarButtonUI];
}
- (IBAction)buttonTwoAction:(UIButton *)sender {
    self.selectStarCount = 2;
    [self updateStarButtonUI];
}
- (IBAction)buttonThreeAction:(UIButton *)sender {
    self.selectStarCount = 3;
    [self updateStarButtonUI];
}
- (IBAction)buttonFourAction:(UIButton *)sender {
    self.selectStarCount = 4;
    [self updateStarButtonUI];
}
- (IBAction)buttonFiveAction:(UIButton *)sender {
    self.selectStarCount = 5;
    [self updateStarButtonUI];
}

- (void)updateStarButtonUI {
    [self.commentTextView resignFirstResponder];

    switch (self.selectStarCount) {
        case 1:
        {
            [self.buttonOne setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonTwo setImage:[UIImage imageNamed:@"s_icon_xing_normal"] forState:UIControlStateNormal];
            [self.buttonThree setImage:[UIImage imageNamed:@"s_icon_xing_normal"] forState:UIControlStateNormal];
            [self.buttonFour setImage:[UIImage imageNamed:@"s_icon_xing_normal"] forState:UIControlStateNormal];
            [self.buttonFive setImage:[UIImage imageNamed:@"s_icon_xing_normal"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [self.buttonOne setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonTwo setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonThree setImage:[UIImage imageNamed:@"s_icon_xing_normal"] forState:UIControlStateNormal];
            [self.buttonFour setImage:[UIImage imageNamed:@"s_icon_xing_normal"] forState:UIControlStateNormal];
            [self.buttonFive setImage:[UIImage imageNamed:@"s_icon_xing_normal"] forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [self.buttonOne setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonTwo setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonThree setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonFour setImage:[UIImage imageNamed:@"s_icon_xing_normal"] forState:UIControlStateNormal];
            [self.buttonFive setImage:[UIImage imageNamed:@"s_icon_xing_normal"] forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            [self.buttonOne setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonTwo setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonThree setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonFour setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonFive setImage:[UIImage imageNamed:@"s_icon_xing_normal"] forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
            [self.buttonOne setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonTwo setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonThree setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonFour setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
            [self.buttonFive setImage:[UIImage imageNamed:@"s_icon_xing_select"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 底部View -
//匿名评价
- (IBAction)nickNameCommentButton:(UIButton *)sender {
    self.isNickNameComment = !self.isNickNameComment;
    
    if (self.isNickNameComment == YES) {
        [sender setImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
    }else {
        [sender setImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];

    }
    
}

#warning 匿名评价
//提交订单
- (IBAction)commitCommentButton:(UIButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];

    if (self.selectStarCount > 0 && self.commentTextView.text != nil && self.commentTextView.text.length > 0) {
        
        //提交评价
        Manager *manager = [Manager shareInstance];
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        [manager orderCommentWithUserid:manager.memberInfoModel.u_id withOrderId:self.tempSonOrderModel.o_id withStarLevel:[NSString stringWithFormat:@"%ld",self.selectStarCount] withContent:self.commentTextView.text withCommentSuccessBlock:^(id successResult) {
            [SVProgressHUD dismiss];
            //评论成功后，将状态改变
            self.tempSonOrderModel.isreply = @"2";
            //返回刷新
            self.RefreshCommentAfterBlock();
            [alertM showAlertViewWithTitle:nil withMessage:@"评价完毕" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            
        } withCommentFailBlock:^(NSString *failResultStr) {
            [SVProgressHUD dismiss];
            [alertM showAlertViewWithTitle:nil withMessage:@"评价提交失败" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
        
    }else {
        NSLog(@"信息不完整");
        [alertM showAlertViewWithTitle:nil withMessage:@"提交信息不完整，请填写完整后再次提交" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.commentTextView resignFirstResponder];
    
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
