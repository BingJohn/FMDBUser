//
//  ViewController.m
//  FmdbManager
//
//  Created by 王炜圣 on 2018/8/29.
//  Copyright © 2018年 王炜圣. All rights reserved.
//

#import "ViewController.h"
#import "FDDataBaseQueue.h"
#import "FDUserModel.h"
#import "FDNickTableViewCell.h"
#import "FDAddViewController.h"
@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *listData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FMDB数据存储";
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    NSArray *nickData = @[@"吕布",@"赵云",@"典韦",@"关羽",@"张飞"];
    NSArray *contentData = @[@"在北京的灯中，有一盏是我家的。这个梦何时可以实现？哪怕微微亮。北京就像魔鬼训练营，有能力的留，没能力的走",@"尽管没有派出几大主将，而是以更年轻的“二队”出征，中国乒乓球在亚洲的霸主地位依然无人能够撼动。昨日，在雅加达国际会展中心临时改建而成的球馆内，人们再一次见证了中国队的狂欢：女团决赛横扫朝鲜，收获亚运四连冠；男团决赛击败韩国，成就七连冠，而且比分都是3比0。",@"中兴通讯“苏醒”42天：生产已恢复 加大芯片投入",@"亚运跳水再现神级失误，怪不得中国包揽了40年的金牌",@"北京就像魔鬼训练营，有能力的留，没能力的走"];
    NSArray *ageData = @[@"30",@"40",@"20",@"23",@"35"];
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++) {
        int value =arc4random_uniform(4 + 1);
        FDUserModel * model = [[FDUserModel alloc] init];
        model.userId = [NSString stringWithFormat:@"%@",@(20000+i)];
        model.nickName = nickData[value];
        model.content = contentData[value];
        model.age = [ageData[value] integerValue];
        NSDictionary * dic = [model modelToJSONObject];
        [listData addObject:dic];
    }
    [FDDataBaseQueue insertDatasDataBase:listData.copy completion:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(addAction)];
    
    self.listData = @[].mutableCopy;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(FDNickTableViewCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(FDNickTableViewCell.class)];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
}
- (void)addAction
{
    [self.navigationController pushViewController:[FDAddViewController vcWithModel:nil] animated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshData:1];
}
- (void)refreshData:(NSInteger)page
{
    [FDDataBaseQueue getDatasFromDataBase:^(NSArray<NSDictionary *> *arrayData) {
        if (page == 1) {
            [self.listData removeAllObjects];
        }
        NSArray *list = [NSArray modelArrayWithClass:FDUserModel.class json:arrayData];
        [self.listData addObjectsFromArray:list];
        [self.tableView reloadData];
        [self endRefresh:YES];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;//iOS8以后自带计算高度
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDNickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(FDNickTableViewCell.class)];
    cell.model = self.listData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDUserModel *model =self.listData[indexPath.row];
    [self.navigationController pushViewController:[FDAddViewController vcWithModel:model] animated:YES];
}
#pragma mark - 右滑删除功能
#pragma mark -iOS11以下
//左拉抽屉(删除和修改按钮)
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除用户"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        if ([action.title isEqualToString:@"已删除"]){
            return ;
        }
        [self deleteShopCollectionWithShopId:indexPath.row];
    }];
    return @[deleteRowAction];
}
//设置table view 为可编辑的
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//设置可编辑的样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//设置处理编辑情况 就算这个方法里面什么都没有也不要删除 否则右滑失效
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark -iOS11以下
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    UIContextualAction *deleteAction =
    [UIContextualAction
     contextualActionWithStyle:
     UIContextualActionStyleDestructive
     title:@""
     handler:^(UIContextualAction * _Nonnull action,
               __kindof UIView * _Nonnull sourceView,
               void (^ _Nonnull completionHandler)(BOOL)){
         
         if ([action.title isEqualToString:@"已删除"]){
             completionHandler(false);
             return ;
         }
         [self deleteShopCollectionWithShopId:indexPath.row];
     }];
    NSArray *actions = [[NSArray alloc] initWithObjects:deleteAction, nil];
    UISwipeActionsConfiguration* swipeActionsConfiguration = [UISwipeActionsConfiguration configurationWithActions:actions];
    swipeActionsConfiguration.performsFirstActionWithFullSwipe = NO;
    return swipeActionsConfiguration;
}
- (void)deleteShopCollectionWithShopId:(NSInteger)indexPath
{
     FDUserModel *model =self.listData[indexPath];
     NSDictionary *dic = [model modelToJSONObject];
    [FDDataBaseQueue deleteDataToDataBase:dic completion:^(BOOL success) {
        [self refreshData:1];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
