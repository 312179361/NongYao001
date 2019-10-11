//
//  ClassModel.h
//  ShangCheng
//
//  Created by TongLi on 2017/1/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject
@property (nonatomic,strong)NSString *d_code;
@property (nonatomic,strong)NSString *d_value;
@property (nonatomic,strong)NSString *d_desc;
@property (nonatomic,strong)NSMutableArray *subItemArr;
@property (nonatomic,assign)BOOL isMore;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
