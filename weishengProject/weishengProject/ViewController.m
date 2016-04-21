//
//  ViewController.m
//  weishengProject
//
//  Created by weisheng.wang on 16/4/18.
//  Copyright © 2016年 weisheng.wang. All rights reserved.
//

#import "ViewController.h"
#import "weishengModel.h"
#import "weishengDataBaseQueue.h"
@interface ViewController ()
{
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    weishengModel * model = [[weishengModel alloc]init];
    model.user_id = @"1990";
    model.name = @"王炜圣";
    model.age = 26;
    model.height = 171;
#pragma mark 不是线程安全
    //添加一条数据
    [[weishengDataBase ShareInstance] insertTheDataToGroupDataBase:model];
    //读取数据
    [[weishengDataBase ShareInstance] readTheDataToGroupDataBase:^(NSArray * arrayData) {
        NSLog(@"插入一条数据:%@",arrayData);
    }];
    model.name = @"tianya";
    model.age = 20;
    model.height = 190;
    
    //更改数据
    [[weishengDataBase ShareInstance] updateTheDataToGroupDataBase:model];
    //
    [[weishengDataBase ShareInstance] readTheDataToGroupDataBase:^(NSArray * arrayData) {
         NSLog(@"更改一条数据:%@",arrayData);
    }];
    //删除数据
    [[weishengDataBase ShareInstance] deleteTheDataToGroupDataBase:model];
    //
    [[weishengDataBase ShareInstance] readTheDataToGroupDataBase:^(NSArray * arrayData) {
        NSLog(@"删除所有user_id的数据后:%@",arrayData);
    }];
    //删除表格
    [[weishengDataBase ShareInstance] DropTheTableGroupDataBase];
    
#pragma mark 线程安全
    
    //添加一条数据
    [[weishengDataBaseQueue ShareInstance] insertTheDataToGroupDataBase:model];
    //读取数据
    [[weishengDataBaseQueue ShareInstance] readTheDataToGroupDataBase:^(NSArray * arrayData) {
        NSLog(@"插入一条数据:%@",arrayData);
    }];
    model.name = @"tianya";
    model.age = 20;
    model.height = 190;
    
    //更改数据
    [[weishengDataBaseQueue ShareInstance] updateTheDataToGroupDataBase:model];
    //
    [[weishengDataBaseQueue ShareInstance] readTheDataToGroupDataBase:^(NSArray * arrayData) {
        NSLog(@"更改一条数据:%@",arrayData);
    }];
    //删除数据
    [[weishengDataBaseQueue ShareInstance] deleteTheDataToGroupDataBase:model];
    //
    [[weishengDataBaseQueue ShareInstance] readTheDataToGroupDataBase:^(NSArray * arrayData) {
        NSLog(@"删除所有user_id的数据后:%@",arrayData);
    }];
   
    
    //使用事务 批量处理数据插入问题
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (int i = 0; i<1000; i++) {
        weishengModel * model = [[weishengModel alloc]init];
        model.user_id = [NSString stringWithFormat:@"%d",1990+i];
        model.name = @"weisheng.wang";
        model.age = 26;
        model.height = 171;
        [array addObject:model];
        model = nil;
    }
    [[weishengDataBaseQueue ShareInstance] insertTheDataToGroupWithDataBase:array];
    [[weishengDataBaseQueue ShareInstance] readTheDataToGroupDataBase:^(NSArray * arrayData) {
        NSLog(@"使用事务 批量处理数据插入:%@",arrayData);
    }];
    //删除表格
    [[weishengDataBaseQueue ShareInstance] DropTheTableGroupDataBase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
