//
//  FDNickTableViewCell.h
//  FmdbManager
//
//  Created by 王炜圣 on 2018/8/29.
//  Copyright © 2018年 王炜圣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDUserModel.h"
@interface FDNickTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UILabel *sexLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (strong, nonatomic) FDUserModel *model;

- (void)setModel:(FDUserModel *)model;
@end
