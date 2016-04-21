//
//  weishengDataBaseQueue.m
//  weishengProject
//
//  Created by weisheng.wang on 16/4/21.
//  Copyright © 2016年 weisheng.wang. All rights reserved.
//

#import "weishengDataBaseQueue.h"

@implementation weishengDataBaseQueue
+ (weishengDataBaseQueue *)ShareInstance
{
    static weishengDataBaseQueue * theQueueModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!theQueueModel) {
            theQueueModel = [[weishengDataBaseQueue alloc]init];
        }
    });
    return theQueueModel;
}
-(id)init
{
    if (self = [super init]) {
        
       
        
    }
    return self;
}
- (void)createDateBaseQueueTable
{
    NSString * stringPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/House"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath]) {
        BOOL res = [[NSFileManager defaultManager]createDirectoryAtPath:stringPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            NSLog(@"create successful");
        }
    }
    NSString * dbPatch = [stringPath stringByAppendingPathComponent:@"weisheng.sqlite"];
    if (!_dataBaseQueue) {
        _dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPatch];
    }
    
    [_dataBaseQueue inDatabase:^(FMDatabase * dataBase) {
        if ([dataBase open]) {
            //数据库建表
            NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ContactsChangeFriend (data text,user_id text PRIMARY KEY)"];
            [dataBase executeUpdate:sql];
            [dataBase close];
        }
        else
        {
            
        }
    }];
}
- (void)insertTheDataToGroupDataBase:(weishengModel *)modelObject
{
    [self createDateBaseQueueTable];
    [_dataBaseQueue inDatabase:^(FMDatabase * db) {
        if ([db open]) {
            NSData * data = [self archivedDataForOfflineResourceData:modelObject];
            NSString * v5TableSql = [NSString stringWithFormat:@"insert or replace into ContactsChangeFriend (data,user_id) values (?,?)"];
            BOOL res = [db executeUpdate:v5TableSql withArgumentsInArray:@[data,modelObject.user_id]];
            if (res) {
                
            }
            [db close];
        }
    }];
}
- (void)insertTheDataToGroupWithDataBase:(NSArray *)arrayModelObject
{
    [self createDateBaseQueueTable];
    [_dataBaseQueue inDatabase:^(FMDatabase * db) {
        if ([db open]) {
             [db beginTransaction];
            for (weishengModel * modelObject in arrayModelObject) {
                NSData * data = [self archivedDataForOfflineResourceData:modelObject];
                NSString * v5TableSql = [NSString stringWithFormat:@"insert or replace into ContactsChangeFriend (data,user_id) values (?,?)"];
                BOOL res = [db executeUpdate:v5TableSql withArgumentsInArray:@[data,modelObject.user_id]];
                if (res) {
                    
                }
            }
            [db commit];
            [db close];
        }
    }];
}
- (void)updateTheDataToGroupDataBase:(weishengModel *)modelObject
{
    [self createDateBaseQueueTable];
    [_dataBaseQueue inDatabase:^(FMDatabase * db) {
        if ([db open]) {
            NSData * data = [self archivedDataForOfflineResourceData:modelObject];
            NSString * v5TableSql = [NSString stringWithFormat:@"update ContactsChangeFriend set data = ? where user_id = ?"];
            BOOL res = [db executeUpdate:v5TableSql withArgumentsInArray:@[data,modelObject.user_id]];
            if (res) {
                
            }
            [db close];
        }
    }];
}
- (void)deleteTheDataToGroupDataBase:(weishengModel *)modelObject
{
[self createDateBaseQueueTable];
  [_dataBaseQueue inDatabase:^(FMDatabase *db) {
      if ([db open]) {
          [db beginTransaction];
          NSString * v5TableSql = [NSString stringWithFormat:@"delete from ContactsChangeFriend where user_id = %@",modelObject.user_id];
          BOOL res = [db executeUpdate:v5TableSql];
          if (res) {
              [db commit];
              NSLog(@"success to delete db table data");
          }else
          {
              NSLog(@"error when delete db table data");
          }
          [db close];
      }
  }];
    
}
- (void)readTheDataToGroupDataBase:(void(^)(NSArray * arrayData))readTheDataToDataBaseBlock
{
    [self createDateBaseQueueTable];
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString * sql = [NSString stringWithFormat:
                              @"select * from ContactsChangeFriend order by user_id"];
            FMResultSet * rs = [db executeQuery:sql];
            NSData * data;
            NSMutableArray * array = [[NSMutableArray alloc]init];
            while ([rs next])
            {
                data = [rs dataForColumn:@"data"];
                weishengModel * model = [self unarchiveForData:data];
                [array addObject:model];
            }
            [db close];
            readTheDataToDataBaseBlock(array);
        }
    }];
    
}

- (void)DropTheTableGroupDataBase
{
    [self createDateBaseQueueTable];
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString * sqlstr = [NSString stringWithFormat:@"drop table ContactsChangeFriend"];
            BOOL res =  [db executeUpdate:sqlstr];
            if (res) {
                NSLog(@"drop table successful");
            }else
            {
                NSLog(@"drop table fail");
            }
            [db close];
        }
    }];
    
}
- (NSData *)archivedDataForOfflineResourceData:(weishengModel * )data
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
- (id)unarchiveForData:(NSData*)data
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
@end