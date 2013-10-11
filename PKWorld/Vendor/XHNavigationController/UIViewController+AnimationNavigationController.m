//
//  UIViewController+AnimationNavigationController.m
//  CoreApp
//
//  Created by 曾 宪华 on 13-9-2.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import "UIViewController+AnimationNavigationController.h"

@implementation UIViewController (AnimationNavigationController)

- (AnimationNavigationController *)animationNavigationController {
    AnimationNavigationController *navigationController = nil;
    if ([self.navigationController isKindOfClass:[AnimationNavigationController class]])
        navigationController = (AnimationNavigationController *)self.navigationController;
    return navigationController;
}

@end
