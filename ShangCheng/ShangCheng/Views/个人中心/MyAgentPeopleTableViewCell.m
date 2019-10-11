//
//  MyAgentPeopleTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyAgentPeopleTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation MyAgentPeopleTableViewCell
- (void)updateMyAgentPeopleCellWithAgentModel:(MyAgentPeopleModel *)tempModel {
    
    [self.peopleImageView setWebImageURLWithImageUrlStr:tempModel.u_icon withErrorImage:[UIImage imageNamed:@"w_icon_mrtx"] withIsCenter:NO];
    
    self.peopleNameLabel.text = tempModel.u_truename;
    //电话号码隐藏中间四位
    NSString *currentPhoneStr = [tempModel.u_mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.peoplePhoneLabel.text = currentPhoneStr;
    self.peopleAddressLabel.text = [NSString stringWithFormat:@"%@%@%@",tempModel.capitalname,tempModel.cityname,tempModel.countyname];
    self.peopleTimeLabel.text = tempModel.u_time_create;
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.peopleImageView.layer.masksToBounds = YES;
//    self.peopleImageView.layer.cornerRadius = self.peopleImageView.bounds.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
