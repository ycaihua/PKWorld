//
//  HealthHomeViewController.m
//  PKWorld
//
//  Created by 曾 宪华 on 13-9-30.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import "HealthTableViewController.h"
#import "PhotosTableViewController.h"

@interface HealthTableViewController ()

@end

@implementation HealthTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadDataSource];
}

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

#pragma mark - XHPageDelegate

- (void)configureWithModel:(id)model {
    
}

#pragma mark - UITableView

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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    UINavigationController *navi = self.navigationController;
    PhotosTableViewController *news = [[PhotosTableViewController alloc] init];
    [navi pushViewController:news animated:YES];
}

@end
