//
//  PKWorldDetailViewController.m
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-11.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import "PKWorldDetailViewController.h"

@interface PKWorldDetailViewController ()

@end

@implementation PKWorldDetailViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.xh_drawerController setOpenDrawerGestureModeMask:XHOpenDrawerGestureModeNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.xh_drawerController setOpenDrawerGestureModeMask:XHOpenDrawerGestureModeAll];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
