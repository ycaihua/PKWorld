//
//  SecretHomeViewController.m
//  PKWorld
//
//  Created by 曾 宪华 on 13-9-30.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import "SecretTableViewController.h"
#import "PhotosTableViewController.h"

@interface SecretTableViewController ()

@end

@implementation SecretTableViewController

#pragma mark - DataSource

- (void)loadDataSource {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *root = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DataSource" ofType:@"plist"]];
        NSArray *dataSource = [root valueForKey:@"DataSource"];
        
        __block NSMutableArray *dataSources = [[NSMutableArray alloc] init];
        for (NSString *item in dataSource) {
            [dataSources addObject:item];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataSource = dataSources;
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Left cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 这个是获取本地数据，因为一开始就给他数据了
    [self loadDataSource];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 在这里进行下拉刷新反应
    // 然后根据网络情况下载数据
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XHPageDelegate

- (void)configureWithModel:(id)model {
    self.mainCenterModel = model;
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSString *itemTitle = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = itemTitle;
    cell.imageView.image = [UIImage imageNamed:@"meicon.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    UINavigationController *navi = self.navigationController;
    PhotosTableViewController *news = [[PhotosTableViewController alloc] init];
    [navi pushViewController:news animated:YES];
}

@end
