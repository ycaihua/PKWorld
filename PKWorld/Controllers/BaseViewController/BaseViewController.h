//
//  BaseViewController.h
//  PKWorld
//
//  Created by 曾 宪华 on 13-9-30.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCenterModel.h"

@interface BaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, XHPageProtocol>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) MainCenterModel *mainCenterModel;
@end
