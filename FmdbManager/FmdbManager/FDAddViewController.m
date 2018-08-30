//
//  FDAddViewController.m
//  FmdbManager
//
//  Created by 王炜圣 on 2018/8/29.
//  Copyright © 2018年 王炜圣. All rights reserved.
//

#import "FDAddViewController.h"
#import "FDDataBaseQueue.h"
#import <Masonry.h>
@interface FDAddViewController ()
@property (strong, nonatomic) UITextField *nickName;
@property (strong, nonatomic) UITextField *age;

@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UITextView *content;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) FDUserModel *model;

@end

@implementation FDAddViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+ (instancetype)vcWithModel:(FDUserModel *)model
{
    FDAddViewController *vc = [[FDAddViewController alloc] init];
    vc.model = model;
    return vc;
}
- (UITextField *)nickName
{
    if (!_nickName) {
        _nickName = [[UITextField alloc] init];
        _nickName.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _nickName;
}
- (UITextField *)age
{
    if (!_age) {
        _age = [[UITextField alloc] init];
        _age.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _age;
}
- (UITextView *)content
{
    if (!_content) {
        _content = [[UITextView alloc] init];
    }
    return _content;
}
- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    }
    return _saveButton;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
- (void)saveAction:(UIButton *)sender
{
    if (self.nickName.text.length == 0) {
        NSLog(@"昵称不能为空");
        return;
    }
    if (self.age.text.length == 0) {
        NSLog(@"年纪不能为空");
        return;
    }
    self.model.nickName = self.nickName.text;
    self.model.age = self.age.text.integerValue;
    self.model.content = self.content.text;
    if (self.model.userId.length == 0) {
        self.model.userId = @"10001";
    }
    NSDictionary *dic = [self.model modelToJSONObject];
    [FDDataBaseQueue insertDataToDataBase:dic completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (FDUserModel *)model
{
    if (!_model) {
        _model = [[FDUserModel alloc] init];
    }
    return _model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    [self.saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self loadUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 键盘处理
- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self updateKeyboardAvoidHeight:keyboardHeight];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    [self updateKeyboardAvoidHeight:0];
}
- (void)updateKeyboardAvoidHeight:(CGFloat)keyboardHeight {
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
}
- (void)loadUI
{
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 5.0f;
    self.saveButton.layer.borderWidth = 1.0f;
    self.saveButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.content.layer.masksToBounds = YES;
    self.content.layer.cornerRadius = 5.0f;
    self.content.layer.borderWidth = 1.0f;
    self.content.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.age.text = [NSString stringWithFormat:@"%@",@(self.model.age)];
    self.nickName.text = self.model.nickName;
    self.content.text = self.model.content;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.width.equalTo(self.scrollView.superview);
    }];
    
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView.superview);
        make.width.equalTo(self.view);
        make.height.greaterThanOrEqualTo(@(self.view.frame.size.height - 64));
    }];
    
    [self.contentView addSubview:self.nickName];
    [self.contentView addSubview:self.age];
    [self.contentView addSubview:self.content];
    [self.contentView addSubview:self.saveButton];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.nickName.superview).offset(20);
        make.right.equalTo(self.nickName.superview).offset(-20);
        make.height.offset(45);
    }];
    [self.age mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nickName);
        make.top.equalTo(self.nickName.mas_bottom).offset(30);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nickName);
        make.top.equalTo(self.age.mas_bottom).offset(30);
        make.height.offset(150);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nickName);
//        make.top.equalTo(self.content.mas_bottom).offset(100);
        make.bottom.greaterThanOrEqualTo(self.saveButton.superview).offset(-20);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
