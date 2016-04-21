//
//  weishengDataBaseQueue.h
//  weishengProject
//
//  Created by weisheng.wang on 16/4/21.
//  Copyright © 2016年 weisheng.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "weishengModel.h"
@interface weishengDataBaseQueue : NSObject
@property(strong, nonatomic)FMDatabaseQueue * dataBaseQueue;
/**
 *  @brief 单利
 *
 *  @return 单利对象
 */
+ (weishengDataBaseQueue *)ShareInstance;
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
 *  @brief 使用事务来处理批量插入数据问题 效率比较高
 *
 *  @param arrayModelObject weishengModel对象的数组
 */
- (void)insertTheDataToGroupWithDataBase:(NSArray *)arrayModelObject;
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
