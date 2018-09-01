//
//  FDDataBase.m
//  FmdbManager
//
//  Created by 王炜圣 on 2018/8/31.
//  Copyright © 2018年 王炜圣. All rights reserved.
//

#import "FDDataBase.h"
#import <FMDB.h>

@interface FDDataBase()
@property(strong, nonatomic)FMDatabase * dataBase;
@end

@implementation FDDataBase

+ (instancetype)shareInstance
{
    static FDDataBase * _dataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_dataBase) {
            _dataBase = [[[self class] alloc]init];
        }
    });
    return _dataBase;
}
- (instancetype)init
{
    if (self = [super init]) {
        [self createDateBaseTable];
    }
    return self;
}
- (void)createDateBaseTable
{
    if ([self.dataBase open]) {
        NSString * v5TableSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ContactsGroup (id INTEGER PRIMARY KEY AUTOINCREMENT ,data text,userId text)"];
        
        BOOL res = [self.dataBase executeUpdate:v5TableSql];
        [self.dataBase close];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        
    }
}
/**
 *  @brief 插入数据
 */
+ (void)insertDataToDataBase:(NSDictionary *)userInfo completion:(void(^)(BOOL success))completion;
{
    NSString *userId = userInfo[@"userId"];
    if (userId) {
        FMDatabase * dataBase = [FDDataBase shareInstance].dataBase;
        if ([dataBase open]) {
            [dataBase beginTransaction];
            NSData * data = [FDDataBase archivedData:userInfo];
            NSString * v5TableSql = [NSString stringWithFormat:@"insert or replace into ContactsGroup (data,userId) values (?,?)"];
            BOOL res = [dataBase executeUpdate:v5TableSql withArgumentsInArray:@[data,userId]];
            if (!res) {
                NSLog(@"error when insert db table");
            } else {
                NSLog(@"success to insert db table");
                [dataBase commit];
            }
            [dataBase close];
        }
    }
}
/**
 *  @brief 数据更新
 */
+ (void)updateDataToDataBase:(NSDictionary *)userInfo completion:(void(^)(BOOL success))completion
{
    
}
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSDictionary *)userInfo completion:(void(^)(BOOL success))completion
{
    
}
/**
 *  @brief 使用事务来处理批量插入数据问题 效率比较高
 */
+ (void)insertDatasDataBase:(NSArray <NSDictionary *>*)listData completion:(void(^)(BOOL success))completion
{
    
}
/**
 *  @brief 获取数据
 */
+ (void)getDatasFromDataBase:(void(^)(NSArray <NSDictionary *>*listData))completion
{
    
}
/**
 *  @brief 删除表
 */
+ (void)dropTheTableGroupDataBase:(void (^)(BOOL))completion
{
    FMDatabase * dataBase = [FDDataBase shareInstance].dataBase;
    if ([dataBase open]) {
        NSString * sqlstr = [NSString stringWithFormat:@"drop table ContactsGroup"];
        BOOL res =  [dataBase executeUpdate:sqlstr];
        if (res) {
            NSLog(@"drop table successful");
        }else
        {
            NSLog(@"drop table fail");
        }
        [dataBase close];
        !completion ?: completion(res);
    }
}


+ (NSData *)archivedData:(NSDictionary *)data
{
    NSData * resData = nil;
    @try {
        resData = [NSKeyedArchiver archivedDataWithRootObject:data];
    }
    @catch (NSException *exception) {
        NSLog(@"%s,%d,%@", __FUNCTION__, __LINE__, exception.description);
        resData = nil;
    }
    @finally {
        
    }
    
    return resData;
}
+ (id)unarchiveForData:(NSData*)data
{
    
    id resObj = nil;
    @try {
        resObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"%s,%d,%@", __FUNCTION__, __LINE__, exception.description);
        resObj = nil;
    }
    @finally {
        
    }
    
    return resObj;
    
    
}
#pragma mark 属性
- (FMDatabase *)dataBase
{
    if (!_dataBase) {
        NSString * stringPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/House"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath]) {
            BOOL res = [[NSFileManager defaultManager]createDirectoryAtPath:stringPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (res) {
                NSLog(@"create successful");
            }
        }
        NSString * dbPatch = [stringPath stringByAppendingPathComponent:@"FDDataBase.sqlite"];
        _dataBase = [FMDatabase databaseWithPath:dbPatch];
    }
    return _dataBase;
}
@end
