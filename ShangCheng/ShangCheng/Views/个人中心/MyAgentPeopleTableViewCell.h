//
//  MyAgentPeopleTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
@interface MyAgentPeopleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
@property (weak, nonatomic) IBOutlet UILabel *peopleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peoplePhoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *peopleAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleTimeLabel;

- (void)updateMyAgentPeopleCellWithAgentModel:(MyAgentPeopleModel *)tempModel;

@end
