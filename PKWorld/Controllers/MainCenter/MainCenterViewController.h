//
//  MainCenterViewController.h
//  PKWorld
//
//  Created by 曾 宪华 on 13-10-2.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainCenterModel.h"

@interface MainCenterViewController : XHPagesController <XHPagingDataSource>
- (id)initWithMainCenterItemModel:(MainCenterModel *)itemModel;
@end
