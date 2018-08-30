//
//  FDNickTableViewCell.m
//  FmdbManager
//
//  Created by 王炜圣 on 2018/8/29.
//  Copyright © 2018年 王炜圣. All rights reserved.
//

#import "FDNickTableViewCell.h"

@implementation FDNickTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(FDUserModel *)model
{
    _model = model;
    self.titleLab.text = model.nickName ?:@"";
    self.ageLab.text = [NSString stringWithFormat:@"工号:%@",model.userId];
    self.sexLab.text = [NSString stringWithFormat:@"%@岁",@(model.age)];
    self.contentLab.text = model.content ?:@"";
}

@end
