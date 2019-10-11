//
//  SelectAddressView.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/30.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "SelectAddressView.h"

@implementation SelectAddressView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.frame = self.viewRect;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
    }
    return self;
}

- (void)showPickerViewEnterSelectAreaWithAreaInfo:(AreaInfo)tempAreaInfo {
    //显示
    self.hidden = NO;
    //将老的Int赋给新的Int，用于刷新
    self.selectShengInt = self.oldShengInt;
    self.selectShiInt = self.oldShiInt;
    self.selectQuInt = self.oldQuInt;
    //刷新PickView
    [self.areaPickView reloadAllComponents];
    //滚动到Int的地方
    [self.areaPickView selectRow:self.selectShengInt inComponent:0 animated:NO];
    [self.areaPickView selectRow:self.selectShiInt inComponent:1 animated:NO];
    [self.areaPickView selectRow:self.selectQuInt inComponent:2 animated:NO];
    
    
    //block传值，使得点击确定按钮，回传block
//    self.areaIntBlock = tempAreaInt;
    self.areaInfoBlock = tempAreaInfo;
}


#pragma mark - pickerView delegate -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    Manager *manager = [Manager shareInstance];
    if (manager.areaArr.count > 0 ) {
        return 3;
    }else {
        return 0;
    }
}

//每个分区有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    Manager *manager = [Manager shareInstance];
    
    switch (component) {
        case 0:
            //省
            return manager.areaArr.count;
            break;
        case 1:
            //市
        {
            NSArray *shiArr = [manager.areaArr[self.selectShengInt] objectForKey:@"item"];
            return shiArr.count;
            
        }
            
            break;
        case 2:
            //区
        {
            //得到市数组
            NSArray *shiArr = [manager.areaArr[self.selectShengInt] objectForKey:@"item"];
            //得到区数组
            NSArray *quArr = [shiArr[self.selectShiInt] objectForKey:@"item"];
            return quArr.count;
        }
            break;
            
        default:
            return 0;
            break;
    }
    
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    Manager *manager = [Manager shareInstance];
    NSString *titleStr ;
    switch (component) {
        case 0:
            //省
            titleStr = [manager.areaArr[row] objectForKey:@"a_name"];
            break;
        case 1:
            //市
        {
            NSArray *shiArr = [manager.areaArr[self.selectShengInt] objectForKey:@"item"];
            titleStr = [shiArr[row] objectForKey:@"a_name"];
        }
            break;
        case 2:
            //区
        {
            //得到市数组
            NSArray *shiArr = [manager.areaArr[self.selectShengInt] objectForKey:@"item"];
            //得到区数组
            NSArray *quArr = [shiArr[self.selectShiInt] objectForKey:@"item"];
            titleStr = [quArr[row] objectForKey:@"a_name"];
        }
            break;
            
        default:
            break;
    }
    
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 40)] ;
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text =titleStr;
    myView.textColor = kColor(51, 51, 51, 1);
    myView.font = [UIFont systemFontOfSize:16];         //用label来设置字体大小
    return myView;
}

//行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

//选择了哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"点击%ld--%ld",component,row);
    switch (component) {
        case 0:
        {
            //选择省
            self.selectShengInt = row;
            //市和区归0
            self.selectShiInt = 0;
            self.selectQuInt = 0;
            //刷新
            [self.areaPickView reloadComponent:1];
            [self.areaPickView selectRow:0 inComponent:1 animated:YES];
            [self.areaPickView reloadComponent:2];
            [self.areaPickView selectRow:0 inComponent:2 animated:YES];
        }
            break;
        case 1:
        {
            //选择市
            self.selectShiInt = row;
            //区 归0
            self.selectQuInt = 0;
            //刷新
            [self.areaPickView reloadComponent:2];
            [self.areaPickView selectRow:0 inComponent:2 animated:YES];
            
            
        }
            break;
        case 2:
        {
            //选择区
            self.selectQuInt = row;
        }
            break;
            
        default:
            break;
    }
    
}


//取消 选择地区按钮
- (IBAction)cancelSelectAreaButtonAction:(UIButton *)sender {
    
    //消失
    self.hidden = YES;
    
}
//确定选择地区按钮
- (IBAction)enterSelectAreaButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    
    //地区编码记录一下
    //得到省名称
    NSString *shengStr = [manager.areaArr[self.selectShengInt] objectForKey:@"a_name"];
    //得到市数组
    NSArray *shiArr = [manager.areaArr[self.selectShengInt] objectForKey:@"item"];
    //得到市名称
    NSString *shiStr = [shiArr[self.selectShiInt] objectForKey:@"a_name"];
    //得到区数组
    NSArray *quArr = [shiArr[self.selectShiInt] objectForKey:@"item"];
    //得到区名称
    NSString *quStr = @"";
    NSString *tempAreaID;
    if (quArr.count > 0) {
        quStr = [quArr[self.selectQuInt] objectForKey:@"a_name"];
        //得到区编码。执行block
        tempAreaID = [quArr[self.selectQuInt] objectForKey:@"a_num"];
    }else{
        tempAreaID = [shiArr[self.selectShiInt]objectForKey:@"a_num"];
    }
    
    

    //将省市区名称拼接，执行block
    self.areaInfoBlock(tempAreaID ,shengStr ,shiStr ,quStr);

    //将新的Int赋给老的int
    self.oldShengInt = self.selectShengInt;
    self.oldShiInt = self.selectShiInt;
    self.oldQuInt = self.selectQuInt;
    
    //消失
    self.hidden = YES;
    
    
}












/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
