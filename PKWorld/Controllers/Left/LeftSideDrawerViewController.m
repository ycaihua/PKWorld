//
//  LeftSideDrawerViewController.m
//  PKWorld
//
//  Created by 曾 宪华 on 13-9-30.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import "LeftSideDrawerViewController.h"
#import "MainCenterViewController.h"

@interface LeftSideDrawerViewController ()
@property (nonatomic, strong) NSMutableDictionary *childViewControllers;
@end

@implementation LeftSideDrawerViewController

#pragma mark - getter

- (NSMutableDictionary *)childViewControllers {
    if (!_childViewControllers) {
        _childViewControllers = [[NSMutableDictionary alloc] init];
    }
    return _childViewControllers;
}

#pragma mark - Left cycle

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

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"galaxy"]];
    
    CGRect imageViewRect = [[UIScreen mainScreen] bounds];
    imageViewRect.size.width += 909;
    imageViewRect.origin.x -= 320;
    backgroundImageView.frame = imageViewRect;
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:backgroundImageView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(10.0f, 100.0f, 200.0f, 44.0f);
    [closeButton setBackgroundColor:[UIColor whiteColor]];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.tag = 1;
    changeButton.frame = CGRectMake(10.0f, 200.0f, 200.0f, 44.0f);
    [changeButton setTitle:@"Swap" forState:UIControlStateNormal];
    [changeButton setBackgroundColor:[UIColor greenColor]];
    [changeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
    
    UIButton *changeButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton1.tag = 2;
    changeButton1.frame = CGRectMake(10.0f, 300.0f, 200.0f, 44.0f);
    [changeButton1 setTitle:@"Swap1" forState:UIControlStateNormal];
    [changeButton1 setBackgroundColor:[UIColor greenColor]];
    [changeButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeButton1 addTarget:self action:@selector(changeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton1];
    
    UIButton *changeButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton2.tag = 3;
    changeButton2.frame = CGRectMake(10.0f, 400.0f, 200.0f, 44.0f);
    [changeButton2 setTitle:@"Swap2" forState:UIControlStateNormal];
    [changeButton2 setBackgroundColor:[UIColor greenColor]];
    [changeButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeButton2 addTarget:self action:@selector(changeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 控制主页的方法

- (UINavigationController *)addNavigationChildViewController:(NSIndexPath *)indexPath MainCenterItemModel:(MainCenterModel *)itemModel {
    MainCenterViewController *mainCenterViewController = [[MainCenterViewController alloc] initWithMainCenterItemModel:itemModel];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainCenterViewController];
    [self.childViewControllers setObject:navigationController forKey:indexPath];
    return navigationController;
}

- (void)changeButtonPressed:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    UINavigationController *navigationController = [self.childViewControllers objectForKey:indexPath];
    if (!navigationController) {
        MainCenterModel *itemModel = [[MainCenterModel alloc] init];
        switch (sender.tag) {
            case 1:
                itemModel.mainTableViewControllerClassName = @"TheConnotationOfJokesTableViewController";
                itemModel.mainTitle = @"内涵段子";
                break;
            case 2:
                itemModel.mainTableViewControllerClassName = @"NewsTableViewController";
                itemModel.mainTitle = @"新闻";
                break;
            case 3:
                itemModel.mainTableViewControllerClassName = @"PhotosTableViewController";
                itemModel.mainTitle = @"图集";
                break;
            default:
                break;
        }
        navigationController = [self addNavigationChildViewController:indexPath MainCenterItemModel:itemModel];
    }
    
    
    [self.xh_drawerController setMainViewController:navigationController animated:YES closeMenu:YES];
}

- (void)closeButtonPressed {
    [self closeLeft];
}

- (void)closeLeft {
    [self.xh_drawerController closeMenuAnimated:YES completion:^(BOOL finished) {
        if (finished) {
            NSLog(@"动画完成");
        }
    }];
}

@end
