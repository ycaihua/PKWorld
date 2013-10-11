//
//  BaseViewController.m
//  PKWorld
//
//  Created by 曾 宪华 on 13-9-30.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (isIOS7) {
            _tableView.contentInset = UIEdgeInsetsMake(AdptNavigationBarAndStatusBarHeight + ItemBarHeight, 0, 0, 0);
            _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(AdptNavigationBarAndStatusBarHeight + ItemBarHeight, 0, 0, 0);
        }
        [self.view addSubview:self.tableView];
//        [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//            
//        }completion:^(BOOL finished) {
//            
//        }];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XHPageProtocol

- (void)configureWithModel:(id)model {
    
}

#pragma mark - UITableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.xh_drawerController.open)
        return ;
}

@end
