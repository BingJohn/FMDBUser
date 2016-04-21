//
//  weishengDataBase.m
//  weishengProject
//
//  Created by weisheng.wang on 16/4/18.
//  Copyright © 2016年 weisheng.wang. All rights reserved.
//

#import "weishengDataBase.h"

@implementation weishengDataBase
+ (weishengDataBase*)ShareInstance
{
    static weishengDataBase * theQueueModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!theQueueModel) {
            theQueueModel = [[weishengDataBase alloc]init];
        }
    });
    return theQueueModel;
}
-(id)init
{
    if (self = [super init]) {

        NSString * stringPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/House"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath]) {
            BOOL res = [[NSFileManager defaultManager]createDirectoryAtPath:stringPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (res) {
                NSLog(@"create successful");
            }
        }
        NSString * dbPatch = [stringPath stringByAppendingPathComponent:@"weisheng.sqlite"];
        _dataBase = [FMDatabase databaseWithPath:dbPatch];
        [self createDateBaseTable];
    }
    return self;
}
- (void)createDateBaseTable
{
    
    if ([_dataBase open]) {
        NSString * v5TableSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ContactsGroup (id INTEGER PRIMARY KEY AUTOINCREMENT ,data text,user_id text)"];
        
        BOOL res = [_dataBase executeUpdate:v5TableSql];
        [_dataBase close];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        
    }
}
- (void)insertTheDataToGroupDataBase:(weishengModel *)modelObject
{
    if ([_dataBase open]) {
        [_dataBase beginTransaction];
        NSData * data = [self archivedDataForOfflineResourceData:modelObject];
        NSString * v5TableSql = [NSString stringWithFormat:@"insert or replace into ContactsGroup (data,user_id) values (?,?)"];
        BOOL res = [_dataBase executeUpdate:v5TableSql withArgumentsInArray:@[data,modelObject.user_id]];
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
            [_dataBase commit];
        }
         [_dataBase close];
    }
}

- (void)updateTheDataToGroupDataBase:(weishengModel *)modelObject
{
    if ([_dataBase open]) {
        [_dataBase beginTransaction];
        NSData * data = [self archivedDataForOfflineResourceData:modelObject];
        NSString * v5TableSql = [NSString stringWithFormat:@"update ContactsGroup set data = ? where user_id = ?"];
        BOOL res = [_dataBase executeUpdate:v5TableSql withArgumentsInArray:@[data,modelObject.user_id]];
        if (!res) {
            NSLog(@"error when update db table");
        } else {
            NSLog(@"success to update db table");
            [_dataBase commit];
        }
        [_dataBase close];
    }
}

- (void)deleteTheDataToGroupDataBase:(weishengModel *)modelObject
{
    if ([_dataBase open]) {
        [_dataBase beginTransaction];
        NSString * v5TableSql = [NSString stringWithFormat:@"delete from ContactsGroup where user_id = %@",modelObject.user_id];
        BOOL res = [_dataBase executeUpdate:v5TableSql];
        if (res) {
            [_dataBase commit];
            NSLog(@"success to delete db table data");
        }else
        {
            NSLog(@"error when delete db table data");
        }
        [_dataBase close];
    }
}

- (void)readTheDataToGroupDataBase:(void(^)(NSArray * arrayData))readTheDataToDataBaseBlock
{
    if ([_dataBase open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"select * from ContactsGroup order by user_id"];
        FMResultSet * rs = [_dataBase executeQuery:sql];
        NSData * data;
        NSMutableArray * array = [[NSMutableArray alloc]init];
        while ([rs next])
        {
            data = [rs dataForColumn:@"data"];
            weishengModel * model = [self unarchiveForData:data];
            [array addObject:model];
        }
        [_dataBase close];
        readTheDataToDataBaseBlock(array);
    }
}

- (void)DropTheTableGroupDataBase
{
    if ([_dataBase open]) {
        NSString * sqlstr = [NSString stringWithFormat:@"drop table ContactsGroup"];
        BOOL res =  [_dataBase executeUpdate:sqlstr];
        if (res) {
            NSLog(@"drop table successful");
        }else
        {
            NSLog(@"drop table fail");
        }
        [_dataBase close];
    }
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
