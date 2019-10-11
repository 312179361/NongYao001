//
//  SelectProductViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/30.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "SelectProductViewController.h"
#import "Manager.h"
#import "CALayer+LayerColor.h"
#import "IndexButton.h"
#import "UIImageView+ImageViewCategory.h"
#define kButtonW (kScreenW-22-20)/3
#define kButtonH 38

@interface SelectProductViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

//主要view，
@property (weak, nonatomic) IBOutlet UIView *selectProductView;
//底部距离，用于动画展现
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;


@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;

@property (weak, nonatomic) IBOutlet UIView *scrollViewContentView;

@property (weak, nonatomic) IBOutlet UIView *selectButtonView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentHeightLayout;


@end

@implementation SelectProductViewController


//页面将要显示，
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏电池条
    UIApplication *app = [UIApplication sharedApplication];
    app.statusBarHidden = YES;
    
    //选择规格的view在下面隐藏着，
    self.bottomLayout.constant = -kScreenH*2/3-30;
    
    //先要对模型进行修改，因为有可能有的规格下架了
    
    
    //修改约束
    NSInteger buttonNum = self.productDetailModel.productFarmatArr.count;
    NSInteger rowNum = buttonNum/3;//行数
    //如果不能被3整除，说明有余数，就要在加一行，例如 1/3=0
    if (buttonNum % 3 != 0) {
        rowNum++;
    }
    // selectView居上面的高度 53；selectView局下面的高度108
    self.scrollViewContentHeightLayout.constant = 53 + 108 + rowNum*(kButtonH + 10);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //动画进行从底部出现
    [UIView animateWithDuration:.2 animations:^{
        self.bottomLayout.constant = 0 ;
        [self.view layoutIfNeeded];//不加这句话，动画效果就不会显示
    }];
    

}


//页面将要消失，回复电池条
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIApplication *app = [UIApplication sharedApplication];
    app.statusBarHidden = NO;
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //给背景赋值，即上个屏幕的截屏
    self.backImageView.image = self.backImage;
    
    
    //创建button
    for (int i = 0; i < self.productDetailModel.productFarmatArr.count; i++) {
        
        IndexButton *formatButton = [[IndexButton alloc] initWithFrame:CGRectMake(i%3*(kButtonW + 10), i/3*(kButtonH + 10), kButtonW, kButtonH)];
        //附上index
        formatButton.indexForButton = [NSIndexPath indexPathForRow:i inSection:0];
        //button的样式
        formatButton.titleLabel.font = [UIFont systemFontOfSize:14];
        formatButton.titleLabel.numberOfLines = 0;
        formatButton.layer.masksToBounds = YES;
        formatButton.layer.cornerRadius = 4;
        formatButton.layer.borderWidth = 1;
        [formatButton.layer setBorderColorFromUIColor:kccccccColor] ;
        [formatButton setTitleColor:k333333Color forState:UIControlStateNormal];
        //添加点击事件
        [formatButton addTarget:self action:@selector(formatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        formatButton.backgroundColor = [UIColor whiteColor];
        [self.selectButtonView addSubview:formatButton];
        
        ProductFormatModel *formatModel = self.productDetailModel.productFarmatArr[i];
        [formatButton setTitle:formatModel.productst forState:UIControlStateNormal];
        if (formatModel.isSelect == YES) {
            formatButton.backgroundColor = kMainColor;
            [formatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //刷新产品个数
            self.productCountLabel.text = [NSString stringWithFormat: @"%ld",formatModel.seletctCount];
        }
        
    }
    
    
    //更新标题和价格
    [self upSelectProductNameAndPriceWithModel:self.productDetailModel];
    
   
    
    
}

//更新标题和价格
- (void)upSelectProductNameAndPriceWithModel:(ProductDetailModel *)detailModel {
    [self.productImageView setWebImageURLWithImageUrlStr:detailModel.productModel.productImageUrlstr withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    self.productTitleLabel.text = detailModel.productModel.productTitle;
    self.productPriceLabel.text = [NSString stringWithFormat:@"￥%@", detailModel.productModel.productPrice ];
    
    
}


//关闭button
- (IBAction)dismissButtonAction:(UIButton *)sender {
    //block刷新详情页的UI
    self.refreshFormatBlock();
    
    //动画进行,消失在底部
    [UIView animateWithDuration:.2 animations:^{
        self.bottomLayout.constant = -kScreenH*2/3-30;
        [self.view layoutIfNeeded];//不加这句话，动画效果就不会显示
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];

    }];
    
  
    
}

//选择某个规格的buttonAction
- (void)formatButtonAction:(IndexButton *)sender {
    //清理所有的button颜色
    for (UIView *tempView in sender.superview.subviews) {
        if ([tempView isKindOfClass:[IndexButton class]]) {
            IndexButton *tempButton = (IndexButton *)tempView;
            tempButton.backgroundColor = [UIColor whiteColor];
            [tempButton setTitleColor:k333333Color forState:UIControlStateNormal];
        }
    }
    //选中的改变颜色
    sender.backgroundColor = kMainColor;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //清理所有的模型bool选择
    for (ProductFormatModel *tempFormatModel in self.productDetailModel.productFarmatArr) {
        tempFormatModel.isSelect = NO;
    }
    //改变选中的那个模型的bool值
    ProductFormatModel *selectFormatModel = self.productDetailModel.productFarmatArr[sender.indexForButton.row];
    selectFormatModel.isSelect = YES;
    
    NSLog(@"%@",selectFormatModel.s_id);
    
    //将最新的和规格有关的数据 赋给ProductModel模型
    //规格id
    self.productDetailModel.productModel.productFormatID = selectFormatModel.s_id;
    //规格字符串
    self.productDetailModel.productModel.productFormatStr = selectFormatModel.productst;
    //价格
    self.productDetailModel.productModel.productPrice = selectFormatModel.s_price;
    //最小起订数量
    self.productDetailModel.p_standard_qty = selectFormatModel.s_min_quantity;
    //图片
    //产品编码
    self.productDetailModel.p_pid = selectFormatModel.s_code;
    
    //刷新价格和产品名
    [self upSelectProductNameAndPriceWithModel:self.productDetailModel];
    
    //刷新数量ui
    self.productCountLabel.text = [NSString stringWithFormat:@"%ld", selectFormatModel.seletctCount];
    
}



//减少数量按钮
- (IBAction)lessProductNumberAction:(UIButton *)sender {
    for (ProductFormatModel *tempModel in self.productDetailModel.productFarmatArr) {
        //选择的是这个规格
        if (tempModel.isSelect == YES) {
            //修改数量
            if (tempModel.seletctCount <= [tempModel.s_min_quantity integerValue]) {
                NSLog(@"不能少于起订数量");
            }else {
                tempModel.seletctCount--;
                
                //刷新个数UI
                self.productCountLabel.text = [NSString stringWithFormat:@"%ld",tempModel.seletctCount];
            }
            
        }
    }
}

//增加数量按钮
- (IBAction)addProductNumberAction:(UIButton *)sender {
    for (ProductFormatModel *tempModel in self.productDetailModel.productFarmatArr) {
        //选择的是这个规格
        if (tempModel.isSelect == YES) {
            //修改数量
            tempModel.seletctCount++;
                
            //刷新个数UI
            self.productCountLabel.text = [NSString stringWithFormat:@"%ld",tempModel.seletctCount];
            
            
        }
    }

    
}
//确认加入购物车
- (IBAction)enterButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];

    //得到选择的产品个数
    NSString *tempProductCount ;
    for (ProductFormatModel *tempFormatModel in self.productDetailModel.productFarmatArr) {
        if (tempFormatModel.isSelect == YES) {
            tempProductCount = [NSString stringWithFormat:@"%ld",tempFormatModel.seletctCount];
        }
    }
    
    if ([manager isLoggedInStatus] == YES) {
        
        if ([tempProductCount integerValue] > 0) {
            [manager httpProductToShoppingCarWithFormatIdAndCountDic:@[@{@"sid":self.productDetailModel.productModel.productFormatID,@"number":tempProductCount}] withSuccessToShoppingCarResult:^(id successResult) {
                
                [alertM showAlertViewWithTitle:nil withMessage:@"加入购物车成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    //消失
                    [self dismissButtonAction:nil];
                    
                }];
                
                //发送通知，让购物车界面刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShoppingCarVC" object:self userInfo:nil];
                
            } withFailToShoppingCarResult:^(NSString *failResultStr) {
                NSLog(@"加入失败");
                [alertM showAlertViewWithTitle:nil withMessage:@"加入购物车失败，请稍后再试" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }];

        }else {
            [alertM showAlertViewWithTitle:nil withMessage:@"请选择产品规格" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            
        }
        
    }else {
        if (tempProductCount > 0) {
            //未登录,存到本地
            BOOL saveLocationResult = [manager joinLocationShoppingCarWithProductDetailModel:self.productDetailModel withProductCountStr:tempProductCount];
            if (saveLocationResult == YES) {
                [alertM showAlertViewWithTitle:nil withMessage:@"加入购物车成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    //消失
                    [self dismissButtonAction:nil];
                    
                }];
                
                //发送通知，让购物车界面刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShoppingCarVC" object:self userInfo:nil];
            }else{
                //保存本地失败
                [alertM showAlertViewWithTitle:nil withMessage:@"加入购物车失败，请稍后再试" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

            }
            
            
        }else{
            [alertM showAlertViewWithTitle:nil withMessage:@"请选择产品规格" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }
    }
    
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
