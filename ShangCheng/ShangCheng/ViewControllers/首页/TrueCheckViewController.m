//
//  TrueCheckViewController.m
//  NongYiWenYao
//
//  Created by TongLi on 16/9/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "TrueCheckViewController.h"
#import "WebPageViewController.h"
#import "Manager.h"
@interface TrueCheckViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *totalScrollView;

@property (nonatomic,strong)NSMutableArray *dataSourceArr;
//总分类
@property (nonatomic,assign)NSInteger tempBigCategoryInt;
//子分类标记
@property (nonatomic,assign)NSInteger tempLittleCategoryInt;
//------------第一个分区-----------
//第一个分区的子分区button
@property (weak, nonatomic) IBOutlet UIButton *zeroZeroButton;
@property (weak, nonatomic) IBOutlet UIButton *zeroOneButton;
@property (weak, nonatomic) IBOutlet UIButton *zeroTwoButton;
//农药分区的下标线 的左约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1Layout;

@property (weak, nonatomic) IBOutlet UILabel *zeroLabel;

@property (weak, nonatomic) IBOutlet UIImageView *zeroImageView;
@property (weak, nonatomic) IBOutlet UITextField *zoreTextField;
@property (weak, nonatomic) IBOutlet UIButton *zoreSearchButton;
//-------------第二个分区------------

@property (weak, nonatomic) IBOutlet UIButton *oneZerobutton;
@property (weak, nonatomic) IBOutlet UIButton *oneOnebutton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2Layout;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UIButton *oneSearchButton;

//------------第三个分区------------
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet UIButton *twoSearchButton;



@end

@implementation TrueCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSDictionary *dic11 = @{@"labelStr":@"通过登记证号可以查询到农药的相关信息",@"place":@"请输入登记证号",@"img":[UIImage imageNamed:@"s_icon_registration"]};
    NSDictionary *dic12 = @{@"labelStr":@"通过有效成分可以查询到农药的相关信息",@"place":@"请输入有效成分",@"img":[UIImage imageNamed:@"s_icon_ingredient"]};
    NSDictionary *dic13 = @{@"labelStr":@"通过企业名称可以查询到农药的相关信息",@"place":@"请输入企业名称",@"img":[UIImage imageNamed:@"s_icon_enterprise"]};
    NSArray *arr1 = @[dic11,dic12,dic13];

    NSDictionary *dic21 = @{@"labelStr":@"通过登记证号可以查询到农药的相关信息",@"place":@"请输入登记证号",@"img":[UIImage imageNamed:@"s_icon_registration"]};
    NSDictionary *dic22 = @{@"labelStr":@"通过企业名称可以查询到农药的相关信息",@"place":@"请输入企业名称",@"img":[UIImage imageNamed:@"s_icon_enterprise"]};
    NSArray *arr2 = @[dic21,dic22];
    
    self.dataSourceArr = [NSMutableArray arrayWithObjects:arr1,arr2, nil];
    [self updateUI];
    
}

#pragma mark - 选择第一分类下的 子分类 -
- (IBAction)zoreZoreButtonAction:(UIButton *)sender {
    [self dismissKeyBoard];

    if (self.tempLittleCategoryInt != 0) {
        self.tempLittleCategoryInt = 0;
        [self updateUI];
    }
}

- (IBAction)zoreOneButtonAction:(UIButton *)sender {
    [self dismissKeyBoard];

    if (self.tempLittleCategoryInt != 1) {
        self.tempLittleCategoryInt = 1;
        [self updateUI];
    }
}
- (IBAction)zoreTwoButtonAction:(UIButton *)sender {
    [self dismissKeyBoard];

    if (self.tempLittleCategoryInt != 2) {
        self.tempLittleCategoryInt = 2;
        [self updateUI];
    }
}

#pragma mark - 选择第二分类下的 子分类 -

- (IBAction)oneZeroButtonAction:(UIButton *)sender {
    [self dismissKeyBoard];
    if (self.tempLittleCategoryInt != 0) {
        self.tempLittleCategoryInt = 0;
        [self updateUI];
    }
}

- (IBAction)oneOneButtonAction:(UIButton *)sender {
    [self dismissKeyBoard];
    if (self.tempLittleCategoryInt != 1) {
        self.tempLittleCategoryInt = 1;
        [self updateUI];
    }
}



#pragma mark - 选择最上面的分类 -
- (IBAction)segmentChangeAction:(UISegmentedControl *)sender {
    [self dismissKeyBoard];

    if (self.tempBigCategoryInt != sender.selectedSegmentIndex) {
        self.tempBigCategoryInt = sender.selectedSegmentIndex;
        self.tempLittleCategoryInt = 0;
        [self updateUI];

    }
}

#pragma mark - 刷新UI -
- (void)updateUI {
    NSLog(@"%ld--%ld",self.tempBigCategoryInt,self.tempLittleCategoryInt);
    //移动scrollView
    self.totalScrollView.contentOffset = CGPointMake(self.view.bounds.size.width*self.tempBigCategoryInt,0);

    //第一个大分类
    if (self.tempBigCategoryInt == 0) {
        [self.zeroZeroButton setTitleColor:k666666Color forState:UIControlStateNormal];
        [self.zeroOneButton setTitleColor:k666666Color forState:UIControlStateNormal];
        [self.zeroTwoButton setTitleColor:k666666Color forState:UIControlStateNormal];
        
        self.zeroLabel.text = [[self.dataSourceArr[self.tempBigCategoryInt] objectAtIndex:self.tempLittleCategoryInt] objectForKey:@"labelStr"];
        self.zoreTextField.placeholder = [NSString stringWithFormat:@"%@",[[self.dataSourceArr[self.tempBigCategoryInt] objectAtIndex:self.tempLittleCategoryInt] objectForKey:@"place"]];
        self.zoreTextField.text = nil;
        self.zeroImageView.image = [[self.dataSourceArr[self.tempBigCategoryInt] objectAtIndex:self.tempLittleCategoryInt] objectForKey:@"img"];
        switch (self.tempLittleCategoryInt) {
            case 0:
                [self.zeroZeroButton setTitleColor:kMainColor forState:UIControlStateNormal];
                //点击第一个button，即下标先在最左边
                self.line1Layout.constant = 0;
                break;
            case 1:
                [self.zeroOneButton setTitleColor:kMainColor forState:UIControlStateNormal];
                //点击第一个button，即下标先在中间
                self.line1Layout.constant = kScreenW/3;
                break;
            case 2:
                [self.zeroTwoButton setTitleColor:kMainColor forState:UIControlStateNormal];
                //点击第一个button，即下标先在右边
                self.line1Layout.constant = kScreenW*2/3;

                break;
            default:
                break;
        }
        
    }
    
    
    //第二个大分类
    if (self.tempBigCategoryInt == 1) {
        [self.oneZerobutton setTitleColor:k666666Color forState:UIControlStateNormal];
        [self.oneOnebutton setTitleColor:k666666Color forState:UIControlStateNormal];
        
        self.oneLabel.text = [[self.dataSourceArr[self.tempBigCategoryInt] objectAtIndex:self.tempLittleCategoryInt] objectForKey:@"labelStr"];
        self.oneTextField.placeholder = [NSString stringWithFormat:@"%@",[[self.dataSourceArr[self.tempBigCategoryInt] objectAtIndex:self.tempLittleCategoryInt] objectForKey:@"place"]];
        self.oneTextField.text = nil;
        self.oneImageView.image = [[self.dataSourceArr[self.tempBigCategoryInt] objectAtIndex:self.tempLittleCategoryInt] objectForKey:@"img"];

        switch (self.tempLittleCategoryInt) {
            case 0:
                [self.oneZerobutton setTitleColor:kMainColor forState:UIControlStateNormal];
                //点击第一个button，即下标先在最左边
                self.line2Layout.constant = 0;
                break;
            case 1:
                [self.oneOnebutton setTitleColor:kMainColor forState:UIControlStateNormal];
                //点击第一个button，即下标先在中间
                self.line2Layout.constant = kScreenW/2;
                break;
            default:
                break;
        }
        
    }


    
    
}


#pragma mark - 查询按钮 -
- (IBAction)searchZeroButtonAction:(UIButton *)sender {
    [self dismissKeyBoard];
    NSString *webUrl;
    //第一个分类中的搜索
    if (self.tempBigCategoryInt == 0) {
        switch (self.tempLittleCategoryInt) {
            case 0:
                webUrl = [[InterfaceManager shareInstance] getTrueCheckWithCertificateNo:self.zoreTextField.text];
                break;
            case 1:
            {
                webUrl = [[InterfaceManager shareInstance] getTrueCheckWithComposition:self.zoreTextField.text];
                
            }
                break;
            case 2:
                webUrl = [[InterfaceManager shareInstance] getTrueCheckWithCompany:self.zoreTextField.text];
                break;
            default:
                break;
        }
        
        NSArray *parameterArr = @[@"农药真假查询",webUrl];
        [self performSegueWithIdentifier:@"trueCheckToWebViewVC" sender:parameterArr];
    }
    
}


- (IBAction)searchOneButtonAction:(UIButton *)sender {
    
    [self dismissKeyBoard];
    NSString *webUrl;
    //第二个分类中的搜索
    if (self.tempBigCategoryInt == 1) {
        switch (self.tempLittleCategoryInt) {
            case 0:
                webUrl = [[InterfaceManager shareInstance] getTrueCheckTwoWithCertificateNo:self.oneTextField.text];
                break;
            case 1:
                webUrl = [[InterfaceManager shareInstance] getTrueCheckTwoWithCompany:self.oneTextField.text];
                break;
            default:
                break;
        }
        NSArray *parameterArr = @[@"肥料真假查询",webUrl];
        [self performSegueWithIdentifier:@"trueCheckToWebViewVC" sender:parameterArr];

        
    }
    
}

    
- (IBAction)searchTwoButtonAction:(UIButton *)sender {
    [self dismissKeyBoard]; 
    NSString *webUrl;
    if (self.tempBigCategoryInt == 2) {

        //判断是否为纯数字
        if ([self isPureNumandCharacters:self.twoTextField.text] == YES) {
            //是纯数字就要当成证件号搜索
            webUrl = [[InterfaceManager shareInstance] getTrueCheckThreeWithCertificateNo:self.twoTextField.text];
            
        }else{
            //不是纯数字就当成企业名称
            webUrl = [[InterfaceManager shareInstance] getTrueCheckThreeWithCompany:self.twoTextField.text];
        }
        
        NSArray *parameterArr = @[@"微生物真假查询",webUrl];
        [self performSegueWithIdentifier:@"trueCheckToWebViewVC" sender:parameterArr];
        

    }
    
}

//判断是否这个字符串为纯数字。返回值如果是NO就不是纯数字，返回YES就是纯数字
- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}


- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [self dismissKeyBoard];
}


- (void)dismissKeyBoard {
    [self.zoreTextField resignFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    WebPageViewController *webPageVC = [segue destinationViewController];
    webPageVC.tempTitleStr = sender[0];
    webPageVC.webUrl = sender[1];
    
}


@end
