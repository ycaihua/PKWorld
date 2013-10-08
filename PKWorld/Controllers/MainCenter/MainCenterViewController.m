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
    self.view.backgroundColor = [UIColor blackColor];
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mainScrollView.pagingEnabled = YES;
    for (int i = 0; i < 4; i ++) {
        CGRect viewFrame = CGRectMake(i * CGRectGetWidth(self.view.frame), 0, 320, CGRectGetHeight(self.view.frame));
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:viewFrame];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Snip20130926_%d.png", i + 1]];
        [mainScrollView addSubview:imageView];
    }
    [mainScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame) * 4, 0)];
    self.mainScrollView = mainScrollView;
    [self.view addSubview:mainScrollView];
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
