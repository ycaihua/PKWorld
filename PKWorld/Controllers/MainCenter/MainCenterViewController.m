//
//  MainCenterViewController.m
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-2.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import "MainCenterViewController.h"
#import "UIViewController+ConfigureWithModel.h"

@interface MainCenterViewController () {
}
@property (nonatomic, strong) NSArray *pages;
@property (nonatomic, strong) MainCenterModel *itemModel;
@end

@implementation MainCenterViewController

#pragma mark - getter

- (NSArray *)pages {
    if (!_pages) {
        _pages = [[NSArray alloc] init];
    }
    return _pages;
}

- (id)modelAtIndex:(NSUInteger)index{
    return [self.pages objectAtIndex:index];
}

#pragma mark - Action

- (void)openLeft {
    [self.xh_drawerController openMenuAnimated:YES completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Left cycle

- (id)initWithMainCenterItemModel:(MainCenterModel *)itemModel {
    self = [super init];
    if (self) {
        self.itemModel = itemModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.itemModel.mainTitle;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self action:@selector(openLeft)];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self loadDataSource];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark - loadDataSource

- (void)loadDataSource {
    self.dataSource = self;
    self.direction = XHSlidingDirectionHorizontal;
    self.bounces = YES;
    NSArray *dictionary = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"]];
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    for (NSString *className in dictionary) {
        MainCenterModel *model = [MainCenterModel alloc];
        model.mainTableViewControllerClassName = self.itemModel.mainTableViewControllerClassName;
        model.mainTitle = self.itemModel.mainTitle;
        model.pageItemTitle = className;
        model.seleted = NO;
        [pages addObject:model];
    }
    self.pages = pages;
    [self populateAndGoToIndex:0
                      animated:NO];
}

#pragma mark - 重写方法

- (void)pageIndexDidChange:(NSUInteger)pageIndex{
    [self setScrollToTopOfCurrentViewController:YES];
}


#pragma mark -
#pragma mark XHPagingDataSource

- (NSArray *)items {
    return self.pages;
}

- (UIViewController*)viewControllerForIndex:(NSUInteger)index {
    UIViewController *controller = nil;
    MainCenterModel *item = [self modelAtIndex:index];
    controller = [[NSClassFromString(item.mainTableViewControllerClassName) alloc] init];
    if (controller.view) {
        [controller configureWithModel:item];
    }
    return controller;
}


- (NSUInteger)pageCount{
    return self.pages.count;
}

@end
