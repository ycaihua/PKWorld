//
//  UIViewController+XHNavigationController.m
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-11.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import "UIViewController+XHNavigationController.h"

@implementation UIViewController (XHNavigationController)

- (XHNavigationController *)xh_navigationController {
    XHNavigationController *navigationController = nil;
    if ([self.navigationController isKindOfClass:[XHNavigationController class]])
        navigationController = (XHNavigationController *)self.navigationController;
    return navigationController;
}

@end
