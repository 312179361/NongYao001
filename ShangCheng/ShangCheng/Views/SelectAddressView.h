//
//  SelectAddressView.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/30.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"


//回传选择的地区id和地区字符串
typedef void(^AreaInfo)(NSString *areaId, NSString *shengStr, NSString *shiStr, NSString *quStr);

@interface SelectAddressView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
//
@property(nonatomic,assign)CGRect viewRect;

//地区数据源
@property (nonatomic,strong)NSArray *areaArr;
//上次选择的省市县
@property (nonatomic,assign)NSInteger oldShengInt;
@property (nonatomic,assign)NSInteger oldShiInt;
@property (nonatomic,assign)NSInteger oldQuInt;
//--------------------------------
//这次选择的省市县
@property (nonatomic,assign)NSInteger selectShengInt;
@property (nonatomic,assign)NSInteger selectShiInt;
@property (nonatomic,assign)NSInteger selectQuInt;

//控件
@property (weak, nonatomic) IBOutlet UIPickerView *areaPickView;

//block属性
//@property (nonatomic,copy)AreaInt areaIntBlock;
@property (nonatomic,copy)AreaInfo areaInfoBlock;

- (void)showPickerViewEnterSelectAreaWithAreaInfo:(AreaInfo)tempAreaInfo;

@end
