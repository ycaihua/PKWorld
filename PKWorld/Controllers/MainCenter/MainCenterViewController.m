//
//  MainCenterViewController.m
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-2.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import "MainCenterViewController.h"

@interface MainCenterViewController () {

}
@property (nonatomic, strong) UIScrollView *mainScrollView;
@end

@implementation MainCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"main viewDidAppear");
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"main viewWillAppear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"main viewDidDisappear");
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"main viewWillDisappear");
}

- (void)openMenu {
}

- (void)openRight {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
