//
//  MainCenterItemModel.h
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-10.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainCenterModel : NSObject

// main
@property (nonatomic, assign) BOOL isPaging;
@property (nonatomic, copy) NSString *mainTableViewControllerClassName;
@property (nonatomic, copy) NSString *mainTitle;

//Main tableView or view
@property (nonatomic, copy) NSString *pageItemTitle;
@property (nonatomic, assign) BOOL seleted;

// Main tableView or view sync Network
@property (nonatomic, assign) BOOL syncFinish;
@property (nonatomic, copy) NSString *syncUrl;

@end
