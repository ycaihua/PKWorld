//
//  UIViewController+ConfigureWithModel.h
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-9.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ConfigureWithModel) <XHPageProtocol>
- (void)configureWithModel:(id)model;
@end
