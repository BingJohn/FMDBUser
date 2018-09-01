//
//  FDDataBase.h
//  FmdbManager
//
//  Created by 王炜圣 on 2018/8/31.
//  Copyright © 2018年 王炜圣. All rights reserved.
//

#import <Foundation/Foundation.h>
//非线程安全
@interface FDDataBase : NSObject

/**
 *  @brief 插入数据
 */
+ (void)insertDataToDataBase:(NSDictionary *)userInfo completion:(void(^)(BOOL success))completion;;
/**
 *  @brief 数据更新
 */
+ (void)updateDataToDataBase:(NSDictionary *)userInfo completion:(void(^)(BOOL success))completion;;
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSDictionary *)userInfo completion:(void(^)(BOOL success))completion;;
/**
 *  @brief 使用事务来处理批量插入数据问题 效率比较高
 */
+ (void)insertDatasDataBase:(NSArray <NSDictionary *>*)listData completion:(void(^)(BOOL success))completion;
/**
 *  @brief 获取数据
 */
+ (void)getDatasFromDataBase:(void(^)(NSArray <NSDictionary *>*listData))completion;
/**
 *  @brief 删除表
 */
+ (void)dropTheTableGroupDataBase:(void (^)(BOOL))completion;

@end
