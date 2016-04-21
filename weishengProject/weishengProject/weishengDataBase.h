//
//  weishengDataBase.h
//  weishengProject
//
//  Created by weisheng.wang on 16/4/18.
//  Copyright © 2016年 weisheng.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "weishengModel.h"
@interface weishengDataBase : NSObject
{
    
}
@property(strong, nonatomic)FMDatabase * dataBase;
+ (weishengDataBase *)ShareInstance;
/**
 *  @brief 插入数据
 *
 *  @param modelOject
 */
- (void)insertTheDataToGroupDataBase:(weishengModel *)modelObject;
/**
 *  @brief 数据更新
 *
 *  @param modelObject
 */
- (void)updateTheDataToGroupDataBase:(weishengModel *)modelObject;
/**
 *  @brief 删除数据
 *
 *  @param modelObject
 */
- (void)deleteTheDataToGroupDataBase:(weishengModel *)modelObject;
/**
 *  @brief 获取数据
 *
 *  @param readTheDataToDataBaseBlock
 */
- (void)readTheDataToGroupDataBase:(void(^)(NSArray * arrayData))readTheDataToDataBaseBlock;
/**
 *  @brief 删除表格
 */
- (void)DropTheTableGroupDataBase;
@end
