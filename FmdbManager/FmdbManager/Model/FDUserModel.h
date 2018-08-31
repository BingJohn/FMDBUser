//
//  FDUserModel.h
//  FmdbManager
//
//  Created by 王炜圣 on 2018/8/29.
//  Copyright © 2018年 王炜圣. All rights reserved.
//

#import "BaseModel.h"
#import <UIKit/UIKit.h>

@interface FDUserModel : BaseModel

@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *sexType;
@property(nonatomic, copy) NSString *jobName;
@property(nonatomic, copy) NSString *content;

@property(nonatomic, assign) NSInteger age;
@property(nonatomic, assign) CGFloat height;

@end
