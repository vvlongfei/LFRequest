//
//  LFViewController.m
//  LFRequest
//
//  Created by 王龙飞 on 04/29/2020.
//  Copyright (c) 2020 王龙飞. All rights reserved.
//

#import "LFViewController.h"
#import "LFPresenter.h"
#import <Masonry/Masonry.h>

@interface LFViewController ()
@property (nonatomic, strong) LFPresenter *presenter;

@property (nonatomic, strong) UITextView *displayResultView;

@end

@implementation LFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.presenter = [LFPresenter new];
    UIButton *userBtn = [self createButtonWithSelector:@selector(userInfoAction) title:@"用户信息"
                                               bgColor:UIColor.redColor];
    
    UIButton *homeBtn = [self createButtonWithSelector:@selector(homeInfoAction) title:@"首页信息"
                                               bgColor:UIColor.purpleColor];
    
    UIButton *msgBtn = [self createButtonWithSelector:@selector(msgInfoAction) title:@"消息内容"
                                              bgColor:UIColor.blueColor];
    [self.view addSubview:userBtn];
    [self.view addSubview:homeBtn];
    [self.view addSubview:msgBtn];
    
    NSArray<UIButton *> *btnArr = @[userBtn, homeBtn, msgBtn];
    [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:30 tailSpacing:30];
    [btnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.height.offset(50);
    }];
    
    self.displayResultView = [[UITextView alloc] init];
    self.displayResultView.backgroundColor = UIColor.lightGrayColor;
    self.displayResultView.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.displayResultView];
    [self.displayResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(200, 30, 50, 30));
    }];
}

- (void)userInfoAction {
    [self.presenter.userInfoRequest requestParams:@{
        @"userId":@"1233455",
    } header:@{
        @"selfHeader":@"www.feiyu.com"
    } success:^(id rspModel, NSDictionary *rspJson) {
        self.displayResultView.text = [NSString stringWithFormat:@"%@", rspModel];
    } failure:^(NSError *error, id rspModel) {
        self.displayResultView.text = [NSString stringWithFormat:@"%@", error];
    }];
}

- (void)homeInfoAction {
    [self.presenter.homeRequest requestParams:@{
        @"userId":@"1233455",
    } header:@{
        @"selfHeader":@"www.feiyu.com"
    } success:^(id rspModel, NSDictionary *rspJson) {
        self.displayResultView.text = [NSString stringWithFormat:@"%@", rspModel];
    } failure:^(NSError *error, id rspModel) {
        self.displayResultView.text = [NSString stringWithFormat:@"%@", error];
    }];
}

- (void)msgInfoAction {
    [self.presenter.msgRequest requestParams:@{
        @"userId":@"1233455",
    } header:@{
        @"selfHeader":@"www.feiyu.com"
    } success:^(id rspModel, NSDictionary *rspJson) {
        self.displayResultView.text = [NSString stringWithFormat:@"%@", rspModel];
    } failure:^(NSError *error, id rspModel) {
        self.displayResultView.text = [NSString stringWithFormat:@"%@", error];
    }];
}

- (UIButton *)createButtonWithSelector:(SEL)aSelector title:(NSString *)title bgColor:(UIColor *)bgColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title?:@"" forState:UIControlStateNormal];
    [button setBackgroundColor:bgColor?:UIColor.yellowColor];
    [button addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
