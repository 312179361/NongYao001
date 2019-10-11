//
//  MemberManagerViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/10.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MemberManagerViewController.h"
#import "SetNickNameViewController.h"
#import "SelectAddressView.h"
#import "Manager.h"
#import "UIImageView+ImageViewCategory.h"
#import "SVProgressHUD.h"
@interface MemberManagerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (nonatomic,strong) SelectAddressView *selectAddressView;

@end

@implementation MemberManagerViewController
//相机
UIImagePickerController *picker;
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，刷新账户信息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMemberHeaderViewUI:) name:@"refreshMemberInfoUI" object:nil];
        
    }
    return self;
}


- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化图片选择器
    picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;

    //加载地区pickview
    self.selectAddressView = [[[NSBundle mainBundle] loadNibNamed:@"SelectAddressView" owner:self options:nil] firstObject];
    self.selectAddressView.frame = self.view.frame;
    //首先先隐藏
    self.selectAddressView.hidden = YES;
    [self.view addSubview:self.selectAddressView];
    
    //加载用户基本信息
    [self reloadMemberUserInfo];
    
}

//刷新用户头像
- (void)refreshMemberHeaderViewUI:(NSNotification *)sender {
    //刷新一下用户的信息
    [self reloadMemberUserInfo];
}

//加载用户的信息
- (void)reloadMemberUserInfo {
    Manager *manager = [Manager shareInstance];
    //头像
    [self.headerImageView setWebImageURLWithImageUrlStr:manager.memberInfoModel.u_icon withErrorImage:[UIImage imageNamed:@"w_icon_mrtx"] withIsCenter:NO];
    
    self.nickNameLabel.text = manager.memberInfoModel.u_truename;
    self.phoneNumberLabel.text = manager.memberInfoModel.u_mobile;
    self.areaLabel.text = [NSString stringWithFormat:@"%@ %@ %@",manager.memberInfoModel.capitalname,manager.memberInfoModel.cityname,manager.memberInfoModel.countyname];

}

#pragma mark -  头像 -
//头像
- (IBAction)setHeaderTap:(UITapGestureRecognizer *)sender {
    
    //弹出相机或者图库的选择器
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoForCamera];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册选取" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoForPhotoAlbum];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:action3];
    [self presentViewController:alertC animated:YES completion:nil];
    
}


//通过照相机选取图片
- (void)takePhotoForCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.allowsEditing = YES;
        
    }else{
        NSLog(@"摄像头无法打开");
    }
    [self presentViewController:picker animated:YES completion:nil];
    
}

//通过相册选取图片
- (void)takePhotoForPhotoAlbum {
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 拍照的代理方法 -
//当得到照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    Manager *manager = [Manager shareInstance];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *tempImage = nil;
        
        if ([picker allowsEditing]) {
            tempImage = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            tempImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        
        //给图片进行压缩
        UIImage *submitImg = [manager compressOriginalImage:tempImage toMaxDataSizeKBytes:100];
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }
        
        //上传图片
        [manager httpMotifyMemberAvatarWithUserId:manager.memberInfoModel.u_id withMotifyAvatarImage:submitImg withMotifyAvatarSuccess:^(id successResult) {
            [SVProgressHUD dismiss];
            
            //上传成功后，给模型赋值
            manager.memberInfoModel.u_icon = successResult;
            //更新当前页面的头像
            self.headerImageView.image = submitImg;
            //利用通知刷新个人中心的头像
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMemberInfoUI" object:self userInfo:nil];
            
        } withMotifyAvatarFail:^(NSString *failResultStr) {
            //上传失败
            [SVProgressHUD dismiss];
            [[AlertManager shareIntance] showAlertViewWithTitle:nil withMessage:@"上传头像失败" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            
            NSLog(@"%@", failResultStr);
        }];

        
    }
    //隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//当用户取消时
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 设置昵称 -
//昵称
- (IBAction)nickNameViewTao:(UITapGestureRecognizer *)sender {

    [self performSegueWithIdentifier:@"toSetNicknameVC" sender:nil];

}
//地区
- (IBAction)setAreaTap:(UITapGestureRecognizer *)sender {
    
    //得到地区数据，然后显示
    Manager *manager = [Manager shareInstance];
    if (manager.areaArr.count > 0 ) {
        //说明有数据
        NSLog(@"地区成功1");
        //显示pickView
        [self showAddressPickView];
        
    }else {
        //没有数据，就从本地获取或者网络请求
        if ([SVProgressHUD isVisible] == NO) {
            [SVProgressHUD show];
        }

        [manager httpAreaTreeWithSuccessAreaInfo:^(id successResult) {
            NSLog(@"地区成功2");
            [SVProgressHUD dismiss];
            //刷新pickView
            [self showAddressPickView];
            
        } withFailAreaInfo:^(NSString *failResultStr) {
            NSLog(@"地区请求失败");
            [SVProgressHUD dismiss];
            [[AlertManager shareIntance] showAlertViewWithTitle:nil withMessage:@"地区读取失败" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }];
    }

}

//显示pickView
- (void)showAddressPickView {
    Manager *manager = [Manager shareInstance];
    
    [self.selectAddressView showPickerViewEnterSelectAreaWithAreaInfo:^(NSString *areaId, NSString *shengStr, NSString *shiStr, NSString *quStr) {
        
        NSLog(@"地区id%@",areaId);

        if (![manager.memberInfoModel.countycode isEqualToString:areaId]) {
            //如果两个选择了新的地址，就要网络请求修改地址
            
            //可以提交
            [manager httpMotifyMemberInfoWithUserID:manager.memberInfoModel.u_id withUsername:manager.memberInfoModel.u_truename withEmail:manager.memberInfoModel.u_email withQQ:manager.memberInfoModel.u_qq withAreaId:areaId WithMotifyMemberSuccess:^(id successResult) {
                
                //修改成功，更新模型
                manager.memberInfoModel.capitalname = shengStr;
                manager.memberInfoModel.cityname = shiStr;
                manager.memberInfoModel.countyname = quStr;
                manager.memberInfoModel.countycode = areaId;
               
                //更新UI
                self.areaLabel.text = [NSString stringWithFormat:@"%@ %@ %@",shengStr,shiStr,quStr];

                
            } withMotifyMemberFail:^(NSString *failResultStr) {
                [[AlertManager shareIntance] showAlertViewWithTitle:nil withMessage:@"修改地区信息失败" actionTitleArr:nil withViewController:self withReturnCodeBlock:nil];
            }];

            
        }
        

    }];
    
}
//密码设置
- (IBAction)passwordViewTap:(UITapGestureRecognizer *)sender {
    
    [self performSegueWithIdentifier:@"toMotifyPasswordVC" sender:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toSetNicknameVC"]) {
        SetNickNameViewController *setNickNameVC = [segue destinationViewController];
        setNickNameVC.freshNewNameBlock = ^(){
            self.nickNameLabel.text = [Manager shareInstance].memberInfoModel.u_truename;
        };
        
    }
}


@end
